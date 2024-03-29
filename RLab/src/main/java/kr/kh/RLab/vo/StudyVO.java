package kr.kh.RLab.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class StudyVO {
	private int st_num;
	private String st_name;
	private String st_me_id;
	private String st_info;
	private int st_now_people;
	private int st_total_people;
	private String st_re_name;
	private String st_image;
	private int st_state;
	private int al_num;
	private String al_me_id;
	private String al_content;
	private int al_view;
	private String al_type;
  
	private GatherVO gatherVO; // 모집글 관리에서 데이터 한꺼번에 조회할 때 필요
	private StudyMemberVO studyMemberVO; // 나의 스터디 목록 띄울 때 필요
	
	public GatherVO getGatherVO() {
		return gatherVO;
	}
	
	public StudyMemberVO getStudyMemberVO() {
		return studyMemberVO;
	}
}
