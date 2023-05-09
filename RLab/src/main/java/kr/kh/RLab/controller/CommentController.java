package kr.kh.RLab.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.kh.RLab.pagination.CommentCriteria;
import kr.kh.RLab.pagination.PageMaker;
import kr.kh.RLab.service.BoardService;
import kr.kh.RLab.service.CommentService;
import kr.kh.RLab.service.GatherService;
import kr.kh.RLab.service.NotificationService;
import kr.kh.RLab.vo.AlarmVO.AlarmType;
import kr.kh.RLab.vo.BoardVO;
import kr.kh.RLab.vo.CommentVO;
import kr.kh.RLab.vo.GatherVO;
import kr.kh.RLab.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@RestController
@RequestMapping("/comment")
@Slf4j
public class CommentController {

	private final CommentService commentService;
	private final NotificationService notificationService;
	private final BoardService boardService;
	private final GatherService gatherService;
	private final SseController sseController;
	@PostMapping("/create")
	public Map<String, Object> createComment(@RequestBody CommentVO comment,HttpSession session) {
		int result = commentService.createComment(comment);
		// 새 댓글이 생성되면 SSE 이벤트를 전송
		if (result > 0) {
			//board 댓글
			if(comment.getCo_table().equals("board")) {
				BoardVO board = boardService.getBoardByComment(comment.getCo_ex_num());
				String userId = board.getBo_me_id(); // 게시물 작성자의 ID를 가져와야 함
				if(!userId.equals(comment.getCo_me_id())) { //본인이 단 댓글은 제외
					String message = board.getBo_title()+"에 댓글이 달렸습니다";
					notificationService.sendNotificationToUser(userId, message, AlarmType.STUDY);
				}
				//대댓글일 경우 댓글의 작성자한테도 알림 전송
				if(comment.getCo_ori_num()!=comment.getCo_num()) {
					CommentVO oriComment = commentService.getCommentByCoNum(comment.getCo_ori_num());
					userId = oriComment.getCo_me_id();
					String message = oriComment.getCo_content()+"에 대댓글이 달렸습니다";
					notificationService.sendNotificationToUser(userId, message, AlarmType.STUDY);
				}
			}
			//gather 댓글
			else if(comment.getCo_table().equals("gather")){
				GatherVO gather = gatherService.getGatherByComment(comment.getCo_ex_num());
				String userId = gather.getGa_me_id(); // 게시물 작성자의 ID를 가져와야 함
				if(!userId.equals(comment.getCo_me_id())) { //본인이 단 댓글은 제외
					String message = gather.getGa_title()+"에 댓글이 달렸습니다";
					notificationService.sendNotificationToUser(userId, message, AlarmType.GATHER);
				}
				//대댓글일 경우 댓글의 작성자한테도 알림 전송
				if(comment.getCo_ori_num()!=comment.getCo_num()) {
					CommentVO oriComment = commentService.getCommentByCoNum(comment.getCo_ori_num());
					userId = oriComment.getCo_me_id();
					String message = oriComment.getCo_content()+"에 대댓글이 달렸습니다";
					notificationService.sendNotificationToUser(userId, message, AlarmType.GATHER);
				}
			}
		}
		Map<String, Object> map = new HashMap<>();
		map.put("result", result > 0 ? "success" : "fail");
		sseController.sseNewComment(comment.getCo_ex_num(),session);
		return map;
	}

	@PostMapping("/list/{co_ex_num}")
	public Map<String, Object> commentList(CommentCriteria cc, @PathVariable("co_ex_num") int co_ex_num) {
		cc.setPerPageNum(10); // 한 페이지당 컨텐츠 갯수
		int totalCount = commentService.getCommentTotalCount(co_ex_num);
		PageMaker pm = new PageMaker(totalCount, 10, cc);

		List<CommentVO> commentList = commentService.getCommentList(cc);	
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("commentList", commentList);
		resultMap.put("pm", pm);

		return resultMap;
	}

	@PostMapping("/delete")
	public Map<String, Object> comment(@RequestBody CommentVO comment, HttpSession session) {
		Map<String, Object> map = new HashMap<String, Object>();
		MemberVO user = (MemberVO) session.getAttribute("user");
		boolean res = commentService.deleteComment(comment, user);
		map.put("result", res ? "success" : "fail");
		return map;
	}

	@PostMapping("/update")
	public Map<String, Object> commentUpdate(@RequestBody CommentVO comment, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		MemberVO user = (MemberVO) session.getAttribute("user");
		boolean res = commentService.updateComment(comment, user);
		map.put("result", res ? "success" : "fail");
		return map;
	}

	@GetMapping("/count/{boardNum}")
	public int getCommentCount(@PathVariable int boardNum) {
		int commentCount = commentService.getCommentTotalCount(boardNum);
		return commentCount;
	}

}
