package kr.kh.RLab.service;

import java.util.ArrayList;

import kr.kh.RLab.vo.MemberVO;
import kr.kh.RLab.vo.PayDTO;

public interface ReservationService {

	int getUserPoint(String me_id);

	boolean insertPayment(PayDTO payDto);

	void setPaymentSuccessed(String paOrderId, MemberVO user);

	PayDTO getPayDto(String paOrderId);
	
	void deleteCanceledPayment(String receiptId);

	String getItemStrList(String paOrderId);
	
}