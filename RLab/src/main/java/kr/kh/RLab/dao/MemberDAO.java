package kr.kh.RLab.dao;

import org.apache.ibatis.annotations.Param;

import kr.kh.RLab.vo.MemberVO;

public interface MemberDAO {

	int insertMember(@Param("m")MemberVO member);
	
	MemberVO selectMemberById(@Param("me_id")String me_id);

	Object selectMemberByName(@Param("me_name")String me_name);
	
	void updateAuthority(@Param("me_id")String me_id,@Param("me_authority") int i);

	int updateMember(@Param("m")MemberVO member);

	int updateProfile(@Param("m")MemberVO member);
	
	MemberVO selectMemberBySession(String me_session_id);

	void updateSession(MemberVO user);
	
	String findIDByEmail(String email);

	MemberVO findPWByEmail(@Param("id") String id, @Param("email") String email);

	void updatePW(MemberVO memberVO);
	
	int selectMemberByEamil(String me_email);
}