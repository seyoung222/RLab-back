package kr.kh.RLab.dao;

import org.apache.ibatis.annotations.Param;

import kr.kh.RLab.vo.StudyVO;

public interface GatherDAO {

	boolean insertStudy(@Param("study")StudyVO study);

}