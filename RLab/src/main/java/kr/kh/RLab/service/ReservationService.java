package kr.kh.RLab.service;

import kr.kh.RLab.vo.PayDTO;

public interface ReservationService {

	int getUserPoint(String me_id);

	boolean insertPayment(PayDTO payDto);

	PayDTO setPaymentSuccessed(String paOrderId);

}
