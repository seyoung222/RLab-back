<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="<c:url value='/resources/js/jquery.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.validate.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/additional-methods.min.js'></c:url>"></script>
<link rel="stylesheet" href="<c:url value ='/resources/css/common.css?after'></c:url>" />
<link rel="stylesheet" href="<c:url value ='/resources/css/tab_common.css?after'></c:url>" />
<link rel="stylesheet" href="<c:url value ='/resources/css/mypage/mypage_common.css?after'></c:url>" />
<link rel="stylesheet" href="<c:url value ='/resources/css/table_common.css?after'></c:url>" />
<link rel="stylesheet" href="<c:url value ='/resources/css/mypage/myres_pay.css?after'></c:url>">
<title>작성글 관리</title>

</head>
<body>
	<div id="total_container">
		<!-- main -->
		<main>
			<div id="main_container">
				<!-- aside(left_menu) -->
				<aside class="left_menu_container">
					<nav class="left_menu">
					  <a href="<c:url value='/mypage'></c:url>" class="list_item">마이페이지 홈</a>
		              <a href="<c:url value='/mypage/pwcheck'></c:url>" class="list_item">개인정보 수정</a>
		              <a href="<c:url value='/mypage/myres_pay'></c:url>" class="list_item">예약 관리</a>
		              <a href="./mystudy_favorite.html" class="list_item">스터디 관리</a>
		              <a href="<c:url value='/mypage/mypost_post'></c:url>" class="list_item">작성글 관리</a>
					</nav>
				</aside>
				
				<section>
		            <!-- 탭 -->
		            <div class="tab-container">
		            	<a href="<c:url value='/mypage/myres_pay'></c:url>"  class="tab selected_tab tab1"><div>결제 내역</div></a>
			            <a href="<c:url value='/mypage/myres_book'></c:url>" class="tab unselected_tab tab2"><div>예약 내역</div></a>
		            </div>
		            <div class="my_study_container" id="my_container">
		               <div class="study_card_container">
		
		            	  <!-- table  -->
		                  <div class="table_container">
		                    <div class="select_box_area">
		                      <select name="select_view">
		                        <option value="전체보기">전체보기</option>
		                        <option value="최신 순">최신 순</option>
		                        <option value="작성일 순">작성일 순</option>
		                      </select>
		                    </div>
						<c:if test="${myPayList != null && myPayList.size() != 0}">
		                    <div class="tab_content">
		                      <!-- 나의 게시글 -->
		                      <div class="table_area" id="tabs_1">
		                      <!-- <div class="tab-content_tabel_area 1"> -->
		                        <table class="border_box">
		                          <thead>
		                            <tr class="board_title_list">
		                              <td class="title_list_item">구매번호</td>
		                              <td class="title_list_item">구매일자</td>
		                              <td class="title_list_item">상품명</td>
		                              <td class="title_list_item">총 결제액</td>
		                            </tr>
		                          </thead>
		                          
		                          <tbody>
			                         <c:forEach items="${myPayList}" var="mp" varStatus="vs">						
			                            <tr class="board_list" onclick="location.href='<c:url value='/mypage/myres_pay/${mp.pa_order_id}'></c:url>'">	                           
			                              <td>${mp.pa_order_id}</td>
			                              <td>${mp.pa_date_str2}</td>
			                              <td class="post_title">${mp.pa_order_name}</td>			                 
			                              <td>${mp.pa_amount}</td>                
			                            </tr>
									</c:forEach>
		                          </tbody>
		                        </table>
		                      </div>
		
		                    <!-- 페이지 이동 -->
		                     <div class="page_area">
		                     	<div class="page_box clearfix">
		                     		<c:if test="${pm.prev}">
		                     			<a class="page-link" href="<c:url value='/mypage/mypost_post?page=${pm.endPage-1}'></c:url>">
											<i class="btn_prev"></i>
										</a>
									</c:if>
									<c:forEach begin="${pm.startPage}" end="${pm.endPage}" var="i">
										<span class="page_num">										
											<a class="page-link <c:if test="${pm.cri.page == i}"> active</c:if>" href="<c:url value='/mypage/mypost_post?page=${i}'></c:url>">${i}</a>
										</span>
									</c:forEach>
									<c:if test="${pm.next}">										
										<a class="page-link" href="<c:url value='/mypage/mypost_post?page=${pm.endPage+1}'></c:url>">
											<i class="btn_next"></i>
										</a>
									</c:if>
								</div>
		                     </div>  		                      
		                   </div>
		                 </c:if>
		                 <c:if test="${myPayList.size() == 0 || myPayList == null}">
		                      	<div class="nullMsg">
		                      		<p> 결제내역이 없습니다.</p>
		                      		<a class="btn_link link_favorite" href="<c:url value='/reservation/buy'></c:url>">이용권 구매하기</a>
		                      	</div>
			              </c:if>
		                 </div>
		                </div>
		              </div>  
          		</section> 
			</div>
		</main>
	</div>
<script>	


</script>

</body>
</html>