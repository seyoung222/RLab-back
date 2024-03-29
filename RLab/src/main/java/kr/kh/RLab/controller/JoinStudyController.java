package kr.kh.RLab.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import kr.kh.RLab.service.JoinStudyService;
import kr.kh.RLab.service.StudyService;
import kr.kh.RLab.vo.MemberVO;
import kr.kh.RLab.vo.StudyMemberVO;
import kr.kh.RLab.vo.StudyVO;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
public class JoinStudyController {
	
	private final JoinStudyService joinstudyService;
	
	    @PostMapping("/join")
	    public Map<String, Object> join(@RequestBody StudyMemberVO studyMember,
	    		HttpSession session) {
		 MemberVO member = (MemberVO)session.getAttribute("user"); 
		 
		 return joinstudyService.toggleJoin(studyMember,member,session);
	 }
	 
	 
}
