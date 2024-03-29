<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="<c:url value='/resources/css/reservation/book_seat_select.css'></c:url>" rel="stylesheet">
<script src="<c:url value='/resources/js/jquery.min.js'></c:url>"></script>
<!-- 유효성 검사 validate -->
<script src="<c:url value='/resources/js/jquery.validate.min.js'></c:url>"></script>
<main>
	<div class="container">
		<!-- 주문과정/절차 -->
		<div class="procedure_container clearfix">
			<h1 class="procedure_title">바로예약 [좌석]</h1>
			<ul class="detail_procedure">
				<li class="item_procedure">
					<div class="numbering">01</div>
					<span class="item_text">지점 선택</span>
				</li>
				<i class="icon_next"></i>
				<li class="item_procedure selected">
					<div class="numbering">02</div>
					<span class="item_text">좌석,이용권 선택</span>
				</li>
				<i class="icon_next"></i>
				<li class="item_procedure">
					<div class="numbering">03</div>
					<span class="item_text">예약완료</span>
				</li>
			</ul>					
		</div>


		<div class="main_container">
			<form action="<c:url value='/reservation/1/book'></c:url>" method="post">
				<!-- 좌석 선택 박스 -->
				<div class="seat_container main_content">
					<!-- 타이틀 영역-->
					<div class="title_area">
						<i class="icon_seat"></i>
						<h2>좌석 선택</h2>
						<i class="icon_info info_seat"></i>
					</div>
					<!-- 좌석 선택 영역 -->
					<div class="seat_area">
						<div class="seat_table">
							<table>
								<c:forEach begin="0" end="${seList.size()-1}" step="10" var="i">
									<tr class="<c:if test='${i==0}'>row_1</c:if>">
										<c:forEach begin="${i}" end="${i+9}" var="index">
											<td class="
												<c:if test='${seList.get(index).se_usable==0}'></c:if>
												<c:if test='${seList.get(index).se_usable==1}'>seat_unavailable</c:if>
												<c:if test='${seList.get(index).se_usable==2}'>seat</c:if>
											">${seList.get(index).se_name}</td>
										</c:forEach>
									</tr>
								</c:forEach>
							</table>
						</div>
						<div class="seat_info">
							<div class="seat_info_box">
								<div class="info_unavailable info"></div><p>예약불가</p>
							</div>
							<div class="seat_info_box">
								<div class="info_available info"></div><p>예약가능</p>
							</div>
							<div class="seat_info_box">
								<div class="info_selected info"></div><p>선택한 좌석</p>
							</div>
						</div>
					</div>
					<!-- 선택한 좌석번호 영역 -->
					<div class="seat_num_area">
						<h3>[${br.br_re_name}] ${br.br_name}<input type="hidden" name="br_num" value="${br_num}"></h3>
						<div class="seat_num_box">
							<div class="seat_num_title">선택한 좌석번호 :</div> <div id="seat_num"><input type="hidden" name="se_name" value="">17</div><div class="seat_num_title">번</div>
						</div>
					</div>
				</div>
				
				<!-- 이용권 선택 박스 -->
				<div class="ticket_container main_content">
					<!-- 타이틀 영역 -->
					<div class="title_area">
						<h2>이용권 선택</h2>
						<i class="icon_info info_ticket"></i>
					</div>
					<!-- 이용권 고르기 영역 -->
					<div class="ticket_area">
						<select id="ticket_select" name="re_to_num">
							<c:forEach items="${toList}" var="to">
								<option value="${to.to_num}" data-rest="${to.to_rest_time}">${to.tt_name}(${to.ti_name}) ~${to.to_valid_date_str}</option>
							</c:forEach>
						</select>
						<select class="time_select display_none" name="re_hours">
						</select>
					</div>
					
					<!-- 선택한 이용권, 시간 영역 -->
					<div class="title_area">
						<h2>선택한 이용권</h2>
						<i class="icon_info info_ticket"></i>
					</div>
					<div class="selected_area">
						<div class="selected_ticket display_none">
							<div class="selected_title">1회 이용권 (2시간)</div>
						</div>
						<div class="selected_ticket">
							<div class="selected_title">시간 패키지 (30시간)</div>
							<div class="selected_time">100시간 (남은 이용권 시간 : 29시간)</div>
						</div>
					</div>
					<!-- 이용권 구매, 예약하기 버튼 영역 -->
					<div class="btn_area area">
						<a href="<c:url value='/reservation/buy'></c:url>" class="b_btn"  id="buy_btn"><input type="button" value="이용권 구매"></a>
						<button class="b_btn" id="book_btn"><input type="submit" value="예약하기" ></button>
					</div>
				</div>
			</form>
		</div>
	</div>
</main>
<script>
/* 좌석 선택 관련 이벤트 */
let seatNum = '';
seatInit();
$('.seat').click(function(){
	seatNum = $(this).text();
	$('.seat_table .seat_selected').removeClass('seat_selected').addClass('seat');
	$(this).removeClass('seat').addClass('seat_selected');
	$('.seat_num_box').html('<div class="seat_num_title">선택한 좌석번호 :</div> <div id="seat_num"><input type="hidden" name="se_name" value="">'+seatNum+'</div><div class="seat_num_title">번</div>');
	$('input[name=se_name]').attr('value',seatNum);
})

$('.seat_selected').click(function(){
	seatInit();
})


/* 이용권 선택 관련 이벤트 */
let ticket = '';
let useTime;
let restTime;
let selectedStr = '';

//가진 이용권이 없을 때
if(${toList.size() == 0}){
	$('.ticket_area').html('<div class="no_ticket">사용가능한 이용권이 없습니다. 이용권을 새로 구매해보세요.</div>');
	$('.selected_area').html(selectedStr);
}else{
	showSelectedTicket('${toList.get(0).to_num}');
}

$('#ticket_select').change(function(){
	let re_to_num = $(this).val();
	showSelectedTicket(re_to_num);
});



$(function(){
	$('.time_select').change(function(){
		useTime = $(this).val();
		if(useTime>restTime){
			alert('사용가능한 이용권 잔여시간보다 더 많은 시간을 선택하였습니다.');
			$(this).val(1).prop("selected",true);
			useTime = 1;
		}
		selectedStr = 
			'<div class="selected_ticket">'
			+'<div class="selected_title">'+ticket+'</div>'
			+'<div class="selected_time">'+useTime+'시간 (남은 이용권 시간 : '+(restTime-useTime)+'시간)</div>'
			+'</div>';
		$('.selected_area').html(selectedStr);
	})
});

//좌석을 선택하지 않았을 때 폼 제출 방지
$(document).ready(function() {
	$('form').submit(function(event) {
		if(${myRsv == null}){
			console.log('예약된 정보 없음');
		}else{
			if ( seatNum == '') {
	            event.preventDefault(); // 폼 제출 방지
	            alert('좌석을 선택하세요.');
	        }
	    	if( ${toList.size() == 0}){
	    		event.preventDefault();
	    		alert('등록된 이용권이 없을 경우, 이용권 구매를 먼저 진행하세요.');
	    	}
			event.preventDefault();
			if(confirm('이미 사용중인 이용권이 존재합니다. 마이페이지로 이동하시겠습니까?'))
				location.href='<c:url value="/mypage"></c:url>';
		}
    });
});


//선택된 이용권을 보여주는 함수
function showSelectedTicket(to_num){
	//가진 이용권이 없을 때
	if(${toList.size() == 0}){
		$('.ticket_area').html('<div class="no_ticket">사용가능한 이용권이 없습니다. 이용권을 새로 구매해보세요.</div>');
		$('.selected_area').html(selectedStr);
		return;		
	}
	ticket = $('#ticket_select option:checked').text().split(' 이용권)')[0]+')';
	restTime = +$('#ticket_select option:checked').data('rest');
	
	let ticketName = $('#ticket_select option:checked').text().substr(0,6);
	if(ticketName=='시간 패키지'){
		//시간패키지 선택하면 해당 이용권의 남은시간 불러와서 그 시간만큼 선택창 보이게
		$('.time_select').removeClass('display_none');
		$.ajax({
	        url: '<c:url value="/reservation/1/${br_num}"></c:url>',
	        type: 'POST',
	        data: JSON.stringify({
	            'to_num': to_num
	        }),
	        contentType: 'application/json',
	        dataType: 'json',
	        success: function(data) {
	        	let str ='';
	        	for(i=1; i<data+1; i++)
	        		str += '<option value="'+i+'">'+i+'시간</option>';
        		$('.time_select').html(str);
	        }
	    });
		//이용권 선택창 재구성
		selectedStr = 
		'<div class="selected_ticket">'
		+'<div class="selected_title">'+ticket+'</div>'
		+'<div class="selected_time">1시간 (남은 이용권 시간 : '+(restTime-1)+'시간)</div>'
		+'</div>';
	}else{
		$('.time_select').addClass('display_none');
		selectedStr = 
		'<div class="selected_ticket">'
		+'<div class="selected_title">'+ticket+'</div>'
		+'</div>';
	}
	$('.selected_area').html(selectedStr);
}

//좌석 상태를 초기화하는 함수
function seatInit(){
	$('.seat_table .seat_selected').removeClass('seat_selected').addClass('seat');
	$('.seat_num_box').html('<div class="seat_num_title">좌석을 선택하세요.</div>');
}
</script>