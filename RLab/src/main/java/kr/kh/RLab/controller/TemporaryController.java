package kr.kh.RLab.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.kh.RLab.service.TemporaryService;
import kr.kh.RLab.vo.MemberVO;
import kr.kh.RLab.vo.TemporaryVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/temporary")
public class TemporaryController {
	
	private final TemporaryService temporaryService;
	
	@PostMapping("/save")
	@ResponseBody
	public String saveTemporary(@RequestBody TemporaryVO temporaryVO) {
			if(temporaryService.saveTemporary(temporaryVO)) {
				return "success";	
			}else {
				return "error";				
			}
	}
	
	@GetMapping("/list")
	@ResponseBody
	public ArrayList<TemporaryVO> ListTemporary(HttpServletRequest request) {
		MemberVO member = (MemberVO)request.getSession().getAttribute("user");
	    ArrayList<TemporaryVO> tempList = temporaryService.getTemporaryList(member.getMe_id());
	    return tempList;
	}
	
	//전체삭제
	@PostMapping("/deleteAll")
	@ResponseBody
	public String deleteAllTemporary() {
		temporaryService.deleteAll();
		return "success";
	}
	
	//개별삭제
	@PostMapping("/delete/{te_num}")
	@ResponseBody
	public String deleteTemporary(@PathVariable int te_num) {
		temporaryService.delete(te_num);
		return "success";
	}
}
