package kr.kh.RLab.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.kh.RLab.dao.ReservationDAO;
import kr.kh.RLab.pagination.ReservationCriteria;
import kr.kh.RLab.vo.BranchVO;
import kr.kh.RLab.vo.GrowthVO;
import kr.kh.RLab.vo.ItemVO;
import kr.kh.RLab.vo.MemberVO;
import kr.kh.RLab.vo.PayDTO;
import kr.kh.RLab.vo.ReservationVO;
import kr.kh.RLab.vo.SeatVO;
import kr.kh.RLab.vo.TicketOwnVO;

@Service
public class ReservationServiceImp implements ReservationService {
	
	@Autowired
	ReservationDAO reservationDao;

	@Override
	public int getUserPoint(String me_id) {
		return reservationDao.selectAllPointById(me_id);
	}

	@Override
	public boolean insertPayment(PayDTO payDto) {
		if(payDto.getPa_order_id().equals("")) {
			System.out.println("pa_order_id가 없습니다.");
			return false;
		}
		if(reservationDao.insertPay(payDto)==0) { //pay에 등록
			System.out.println("pay 등록 실패");
			return false;
		}
		if(reservationDao.insertPayDetail(payDto.getPa_order_id(), payDto.getItemList()) == 0){ //pay_detail에 '결제중'으로 등록
			System.out.println("pay_detail 등록 실패");
			return false;
		}
		return true;
	}

	@Override
	public void setPaymentSuccessed(String paOrderId, MemberVO user) {
		System.out.println("넘어온 pa_order_id:"+paOrderId);
		PayDTO pay = reservationDao.selectPayByPaOrderId(paOrderId);
		
		if(!pay.getPa_me_id().equals(user.getMe_id())) {
			System.out.println("로그인한 사용자와 구매진행자 정보가 일치하지 않습니다.");
			return;
		}
		ArrayList<ItemVO> pdList = reservationDao.selectPayDetailByPaOrderId(paOrderId);
		for(ItemVO pd : pdList) {
			//pay_detail 테이블 '결제완료'로 업데이트
			if(reservationDao.updatePayDetailState(pd)==0) {
				System.out.println("결제완료 변경 실패");
				return;
			}
			//ticket_own 테이블에 구매한 티켓들 추가
			for(int i=0; i<pd.getPd_amount(); i++) {
				if(reservationDao.insertTicketOwn(pay.getPa_me_id(),paOrderId,pd) == 0) {
					System.out.println("ticket_own 데이터 입력 실패");
					return;
				}
			}
		}
		//member 누적적립액 수정
		if(reservationDao.updateMePoint(pay) == 0) {
			System.out.println("누적적립액 적용 실패");
			return;
		}
		//point 적립/사용내역 추가 (적립,사용액이 0이 아닐때만)
		if(pay.getPa_point()!=0)
			reservationDao.insertPoint(pay);
		if(pay.getPa_used_point()!=0)
			reservationDao.insertUsedPoint(pay);
		
	}

	@Override
	/**
	 * pay, pay_detail 테이블의 정보를 가져와서 PayDTO 객체를 만드는 메소드
	 * PayDTO안에 있는 ItemVO(=pay_detail)리스트도 불러와서 set함 
	 * @param String pa_order_id - pay 테이블 정보를 불러올때 필요한 기본키
	 */
	public PayDTO getPayDto(String paOrderId) {
		PayDTO pay = reservationDao.selectPayByPaOrderId(paOrderId);
		if(pay==null)
			return null;
		ArrayList<ItemVO> pdList = reservationDao.selectPayDetailByPaOrderId(paOrderId);
		pay.setItemList(pdList);
		return pay;
	}
	
	@Override
	public void deleteCanceledPayment(String orderId) {
		//pd테이블 삭제
		reservationDao.deletePayDetailByPaOrderId(orderId);
		//pay테이블 삭제
		reservationDao.deletePayByPaOrderId(orderId);
	}

	@Override
	public String getItemStrList(String paOrderId) {
		ArrayList<String> itemStrList = reservationDao.selectItemStrList(paOrderId);
		String itemStr = String.join(", ", itemStrList);
		return itemStr;
	}

	@Override
	public ArrayList<BranchVO> getAllBranchList(ReservationCriteria cri) {
		return reservationDao.selectAllBranch(cri);
	}

	@Override
	public int getBranchTotalCount(ReservationCriteria cri) {
		return reservationDao.selectBranchTotalCount(cri);
	}
	
	@Override
	public BranchVO getBranchByBrNum(int br_num) {
		return reservationDao.selectBranchByBr_num(br_num);
	}

	@Override
	public ArrayList<TicketOwnVO> getSeatTicketOwnListById(String me_id) {
		return reservationDao.selectSeatTicketOwnById(me_id);
	}

	/** 사용자 아이디와 예약분류번호(1=좌석/2=캐비닛)로 현재 사용중인 예약 정보를 불러오는 메소드 
	 * @param int kind 좌석/캐비닛을 구분하는 번호
	 * @param String me_id 사용자 아이디
	 * @return 아이디와 좌석으로 찾은 나의 현재 예약정보(ReservationVO객체)
	 */
	@Override
	public ReservationVO getMyReservation(int kind, String me_id) {
		return reservationDao.selectMyReservation(kind, me_id);
	}

	@Override
	public void reserveSeat(ReservationVO book) {
		//사용시간(re_hours) 설정: 시간패키지면 값이 등록되어있는데 아닐 경우 해당 이용권의 ti_period값을 가져와서 set
		int tiNum = reservationDao.selectTiNum(book.getRe_to_num());
		if(tiNum!=6 && tiNum!=7 && tiNum!=8) 
			book.setRe_hours(reservationDao.selectTiPeriod(tiNum));

		//reservation에 추가
		if(reservationDao.insertReservation(1,book)!=0)
			System.out.println("좌석 예약추가 성공");
		
		//to_rest_time 소유중인 이용권의 잔여시간 감소(시간패키지면 사용시간만큼, 아니면 ti_period만큼)
		reservationDao.updateTicketRestTime(book);
		//잔여시간이 0이면 to_state를 0으로 변경
		if(reservationDao.selectRestTime(book.getRe_to_num())<=0)
			reservationDao.updateTicketState(book.getRe_to_num());
		
		//me_use_time 누적이용시간 추가
		if(reservationDao.updateMemberUseTime(book)==0)
			System.out.println("회원 누적사용시간 증가 실패");
		
		//se_usable 상태 변경(가능(2)->불가(1))
		reservationDao.updateSeatUsability(1,book);
		
		GrowthVO myPet = reservationDao.getMypet(book.getRe_me_id());
		//pet있을 경우
		if(myPet != null) {
			//gr_exp 펫 누적경험치 추가(펫의 최대레벨에 해당하는 경험치를 넘어가면 안됨)
			reservationDao.updatePetExp(book);
			//펫의 누적경험치에 따라 해당되는 레벨로 gr_level 다시 세팅
			reservationDao.updateMypetLevel(book.getRe_me_id());
			//펫의 누적경험치에 따라 해당되는 레벨로 gr_ev_num 다시 세팅
		}
	}
	
	@Override
	public void reserveCabinet(ReservationVO book) {
		//사용시간(re_hours) 설정: 해당 이용권의 ti_period값을 가져와서 set
		int tiNum = reservationDao.selectTiNum(book.getRe_to_num());
		book.setRe_hours(reservationDao.selectTiPeriod(tiNum));

		//reservation에 추가
		if(reservationDao.insertReservation(2,book)!=0)
			System.out.println("사물함 예약추가 성공");
		
		//to_rest_time 소유중인 이용권의 잔여시간 감소(시간패키지면 사용시간만큼, 아니면 ti_period만큼)
		reservationDao.updateTicketRestTime(book);
		//잔여시간이 0이면 to_state를 0으로 변경
		if(reservationDao.selectRestTime(book.getRe_to_num())<=0)
			reservationDao.updateTicketState(book.getRe_to_num());
		
		//me_use_time 누적이용시간 추가
		if(reservationDao.updateMemberUseTime(book)==0)
			System.out.println("회원 누적사용시간 증가 실패");
		
		//se_usable 상태 변경(가능(2)->불가(1))
		reservationDao.updateSeatUsability(2,book);
		
		GrowthVO myPet = reservationDao.getMypet(book.getRe_me_id());
		//pet있을 경우
		if(myPet != null) {
			//gr_exp 펫 누적경험치 추가(펫의 최대레벨에 해당하는 경험치를 넘어가면 안됨)
			reservationDao.updatePetExp(book);
			//펫의 누적경험치에 따라 해당되는 레벨로 gr_level 다시 세팅
			reservationDao.updateMypetLevel(book.getRe_me_id());
			//펫의 누적경험치에 따라 해당되는 레벨로 gr_ev_num 다시 세팅
		}
	}

	@Override
	public ReservationVO getReservationByBookInfo(ReservationVO book) {
		int tiNum = reservationDao.selectTiNum(book.getRe_to_num());
		if(tiNum!=6 && tiNum!=7 && tiNum!=8) 
			book.setRe_hours(reservationDao.selectTiPeriod(tiNum));
		return reservationDao.selectReservationByBook(book);
	}

	@Override
	public String getTicketNameByBookInfo(ReservationVO rsv) {
		return reservationDao.selectTicketName(rsv);
	}

	@Override
	public int getRestTime(int re_to_num) {
		return reservationDao.selectTicketRestTime(re_to_num);
	}

	@Override
	public ArrayList<TicketOwnVO> getCabinetTicketOwnListById(String me_id) {
		return reservationDao.selectCabinetTicketOwnById(me_id);
		
	}

	@Override
	public ReservationVO getReservation(int reNum) {
		return reservationDao.selecetReservation(reNum);
	}

	@Override
	public BranchVO getBranchBySeNum(int re_se_num) {
		return reservationDao.selectBranchBySenum(re_se_num);
	}
	
	@Override
	/** 지점 번호와 예약분류번호(1=좌석/2=캐비닛)로 해당 지점의 좌석 위치, 예약가능 여부를 가져옴
	 * @param int br_num - 지점 번호
	 * @param int kind - 좌석/캐비닛을 구분하는 번호
	 * @return 해당 지점의 좌석/캐비닛 리스트(SeatVO 리스트)
	 */
	public ArrayList<SeatVO> getBranchSeat(int br_num, int ki_num) {
		return reservationDao.selectBranchSeat(br_num, ki_num);
	}
	

	@Override
	public ArrayList<BranchVO> getAllBranchListToMain() {
		return reservationDao.selectAllBranchToMain();
	}

}
