package kr.kh.RLab.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.kh.RLab.pagination.GatherCriteria;
import kr.kh.RLab.pagination.PageMaker;
import kr.kh.RLab.service.CommentService;
import kr.kh.RLab.service.GatherService;
import kr.kh.RLab.service.JoinStudyService;
import kr.kh.RLab.vo.BoardVO;
import kr.kh.RLab.vo.CommentVO;
import kr.kh.RLab.vo.FileVO;
import kr.kh.RLab.vo.GatherVO;
import kr.kh.RLab.vo.MemberVO;
import kr.kh.RLab.vo.RegionVO;
import kr.kh.RLab.vo.StudyMemberVO;
import kr.kh.RLab.vo.StudyVO;
import kr.kh.RLab.vo.TagRegisterVO;
import kr.kh.RLab.vo.TagVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/gather")
public class GatherController {

	private final GatherService gatherService;
	private final JoinStudyService joinstudyService;
	private final CommentService commentService;
	
	//스터디생성
	@GetMapping("/insertstudy")
	public ModelAndView studyInsert(ModelAndView mv,HttpServletRequest request) {
		MemberVO member = (MemberVO)request.getSession().getAttribute("user");
	    mv.setViewName("/gather/insertstudy");
	    return mv;
	}
	
	@PostMapping("/insertstudy")
	public ModelAndView studyInsertPost(ModelAndView mv,StudyVO study,HttpServletRequest request,RegionVO region,MultipartFile [] files,
			FileVO file,TagVO tag,TagRegisterVO tagRegister,StudyMemberVO studyMember) {
		MemberVO member = (MemberVO)request.getSession().getAttribute("user");
		boolean res = gatherService.insertStudy(study,member,region,files,file,tag,tagRegister,studyMember);
		mv.setViewName("redirect:/gather/list");
		return mv;
	}
	
	//모집글생성
	@GetMapping("/insertgather")
	public ModelAndView gatherInsert(ModelAndView mv,HttpServletRequest request) {
		MemberVO member = (MemberVO)request.getSession().getAttribute("user");
		ArrayList<StudyVO> list = gatherService.selectStudyById(member);
		mv.addObject("studies",list);
		mv.setViewName("/gather/insertgather");
	    return mv;
	}
	
	@PostMapping("/insertgather")
	public ModelAndView gatherInsertPost(ModelAndView mv,HttpServletRequest request,GatherVO gather) {
		MemberVO member = (MemberVO)request.getSession().getAttribute("user");
		boolean res = gatherService.insertGather(member,gather);
	    mv.setViewName("redirect:/gather/list");
	    return mv;
	}
	
	//메인모집글리스트
	@GetMapping("/list")
	public ModelAndView mainlistgather(ModelAndView mv,GatherCriteria gcri,HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO user = (MemberVO) session.getAttribute("user");
		gcri.sortCri();
		gcri.setPerPageNum(9);
		int totalCount = gatherService.getStudyTotalCount(gcri);
		PageMaker pm = new PageMaker(totalCount, 5, gcri);
		ArrayList<StudyVO> stList = gatherService.selectStudyAll(gcri);
		ArrayList<GatherVO> gaList = gatherService.selectGatherAll();
 		ArrayList<FileVO> fileList = gatherService.selectFileList();
		ArrayList<TagRegisterVO> tagList = gatherService.selectTagList();
		ArrayList<Integer> waList =  gatherService.selectWantedStudyList(user);
		mv.addObject("gaList",gaList);
		mv.addObject("fileList",fileList);
		mv.addObject("user",user);
		mv.addObject("waList",waList);
		mv.addObject("pm",pm);
		mv.addObject("stList",stList);
		mv.addObject("tagList",tagList);
		mv.setViewName("/gather/list");
	    return mv;
	}
	
	
	//모집글 상세보기
	@GetMapping("/detail/{st_num}")
	public ModelAndView gatherDetail(ModelAndView mv,@PathVariable("st_num")int st_num,HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO user = (MemberVO) session.getAttribute("user");
		GatherVO gather = gatherService.getGather(st_num);
		StudyVO study = gatherService.getStudy(st_num);
		ArrayList<TagRegisterVO> tagList = gatherService.selectTagList();
		ArrayList<Integer> waList =  gatherService.selectWantedStudyList(user);
		StudyMemberVO smList = gatherService.selelctJoinStudyMemberList(user,st_num);
		FileVO file =  gatherService.selectFileByStNum(st_num);
		int joinCount = joinstudyService.getJoinCount(st_num);
		MemberVO meList = gatherService.selectStudyMemList(st_num);
		mv.addObject("meList",meList);
		mv.addObject("smList",smList);
		mv.addObject("joinCount",joinCount);
		mv.addObject("st_num",st_num);
		mv.addObject("waList",waList);
		mv.addObject("tgList",tagList);
		mv.addObject("st",study);
		mv.addObject("ga",gather);
		mv.addObject("file",file);
		mv.setViewName("/gather/detail");
	    return mv;
	}
	
	//실시간 태그 검색
	@ResponseBody
	@PostMapping("/search")
	public Map<String,Object> getSearchTagList(@RequestBody TagVO tag) {
		Map<String,Object> map = new HashMap<String,Object>();
		ArrayList<String> tagSearch = gatherService.getSearchTagList(tag.getTa_name());
		//빈 문자열인 경우
		if(tag.getTa_name().equals(""))
			//빈 문자열인 경우 tagSearch를 빈 ArrayList로 초기화
	    		tagSearch = new ArrayList<String>();
		//tagSearch를 "list"라는 키로 map에 추가
		map.put("list", tagSearch);
	    return map;
	}
	
	//모집글 수정 Get
	@GetMapping("/update/{ga_num}")
	public ModelAndView gatherUpdate(ModelAndView mv,HttpServletRequest request,@PathVariable("ga_num")int ga_num) {
		MemberVO user = (MemberVO)request.getSession().getAttribute("user");
		GatherVO ga = gatherService.selectGather(ga_num,user);
		ArrayList<StudyVO> studyList = gatherService.selectStudyNameById(user);
		mv.addObject("studies",studyList);
		mv.addObject("ga",ga);
		mv.setViewName("/gather/update");
		return mv;
	}

	//모집글 수정 Post
	@PostMapping("/update/{ga_num}")
	public ModelAndView boardUpdatePost(ModelAndView mv, @PathVariable int ga_num, 
			GatherVO gather) {
		boolean res = gatherService.updateGather(gather);
		mv.setViewName("redirect:/gather/detail/"+gather.getGa_st_num());
		return mv;
	}
	
	//모집글 삭제 Post
	@PostMapping("/delete/{ga_num}")
	@ResponseBody
	public String deleteGather(@PathVariable("ga_num") int ga_num, HttpServletRequest request) {
		MemberVO user = (MemberVO)request.getSession().getAttribute("user");
		gatherService.deleteGather(ga_num);
		
	    //게시글 삭제할때 해당하는 댓글도 삭제되게 설정
	    ArrayList<CommentVO> comment = commentService.selectCommentByGaNum(ga_num);
	    commentService.deleteCommentAll(comment,user);
	    return "success";
	}
	
	//스터디 수정 Get
	@GetMapping("/updateStudy/{st_num}")
	public ModelAndView studyUpdate(ModelAndView mv,HttpServletRequest request,@PathVariable("st_num")int st_num) {
		MemberVO user = (MemberVO)request.getSession().getAttribute("user");
		StudyVO study = gatherService.selectStudy(st_num);
		FileVO file =  gatherService.selectFileByStNum(st_num);
		ArrayList<String> tagList =  gatherService.selectTagListByStNum(st_num);
		mv.addObject("tagList",tagList);
		mv.addObject("file",file);
		mv.addObject("study",study);
		mv.setViewName("/gather/updateStudy");
		return mv;
	}
	
	//스터디 수정 Post
	@PostMapping("/updateStudy/{st_num}")
	public ModelAndView studyUpdatePost(ModelAndView mv,StudyVO study,HttpServletRequest request,RegionVO region,MultipartFile [] files, FileVO file,
			Integer fileNums,TagVO tag,TagRegisterVO tagRegister,@PathVariable("st_num")int st_num) {
		MemberVO member = (MemberVO)request.getSession().getAttribute("user");
		String msg, url;
		if(gatherService.editStudy(study,member,region,files,file,fileNums,tag,tagRegister,st_num)) {;
			msg ="수정이 완료했습니다.";
			url = "/study/management/study/"+st_num;
		}else {
			msg ="수정에 실패했습니다.";
			url = "/study/management/study/"+st_num;
		}
		mv.addObject("msg", msg);
		mv.addObject("url", url);
		mv.setViewName("/common/message");
		return mv;
	}
	

}