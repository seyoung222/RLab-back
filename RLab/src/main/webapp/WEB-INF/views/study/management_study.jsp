<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="<c:url value='/resources/css/common.css'></c:url>">    
<link rel="stylesheet" href="<c:url value='/resources/css/main.css'></c:url>">
<link rel="stylesheet" href="<c:url value='/resources/css/study/study.css'></c:url>">
<link rel="stylesheet" href="<c:url value='/resources/css/study/management_study.css'></c:url>">
<link rel="stylesheet" href="<c:url value='/resources/css/study/management_member.css'></c:url>">

<main>
	<div id="main_container">
	<!--    <div class="left_side">
				<div class="left_menu_container">
					<nav class="left_menu">
						<a href="<c:url value='/study/${st_num}'></c:url>" class="list_item">스터디홈</a>
						<a href="<c:url value='/study/todo/${st_num}'></c:url>" class="list_item">투두 리스트</a> 
						<a href="<c:url value='/study/daily/${st_num}'></c:url>" class="list_item">데일리 미션</a> 
						<a href="<c:url value='/study/photo/${st_num}'></c:url>" class="list_item">인증 게시판</a> 
						<a href="<c:url value='/board/list/${st_num}'></c:url>" class="list_item">자유 게시판</a> 
						<a href="<c:url value='/study/management'></c:url>" class="list_item">스터디 관리</a>
					</nav>
				</div>
				<a href="#" class="leave_btn">탈퇴하기</a>
			</div>  -->
		<div class="management_container">
			<div class="time_line_title">스터디 관리</div>
		    <div class="content_container">
		    
		    <!-- 스터디 선택 창 -->
		    <div class="select_study_container">
		        <!-- 탭 -->
		        <div class="tab_container">
		            <a href="#" class="item_tab" style="background-color: #f0ea58; font-weight: 700;">스터디 선택</a>
		        </div>
		        <div class="my_study_container" id="my_container">
		            <!-- table  -->
		            <div class="table_container">	
		                <div class="tab_content">	
		                    <!-- 나의 스크랩 -->
		                    <div class="table_area" id="tabs_3">
		                    	<form action="<c:url value='/study/management'></c:url>" method="post" >
			                        <div class="slect_study_box">
			                         <!-- <h3 class="select_study_title">스터디 선택</h3> --> 
			                          <select name="st_num" class="slect_study_list">
	                            		<c:forEach items="${myStudyList}" var="st" varStatus="vs">
		                                	<option value="${st.st_num}" <c:if test="${st.st_num == st_num}">selected</c:if>>${st.st_name}</option>
	                            		</c:forEach>
			                          </select>
			                          <button class="btn_choose">선택</button>
		                    		</div>	 
		                    	</form>                                    
		                    </div>
		                </div>
		            </div>
		        </div>
		     </div>  
		     <!-- 스터디 관리 창 -->
		    <div class="manage_study_container">  
			     <!-- 탭 -->
		        <div class="tab_container">
		            <a href="<c:url value='/study/management/member/${st_num}'></c:url>" class="item_tab unselected tab1">회원 관리</a>
		            <a href="<c:url value='/study/management/study/${st_num}'></c:url>" class="item_tab selected tab2">스터디 관리</a>
		        </div>
		
		        <div class="my_study_container" id="my_container_study">
		            <div class="option_container">
			            <div class="edit_box study_box">
		                	<div class="sb_title">
		                		<h3>스터디 수정</h3>
		                	</div>
		                	<a  href="<c:url value='/gather/updateStudy/${st_num}'></c:url>" >
		                		<button class="btn_edit" >스터디 수정</button>
		                	</a>
		                </div>       
		                <div class="finish_box study_box">
		                    <div class="sb_title">
		                        <h3>스터디 완료 전환</h3>
		                        <i class="icon_info info_1">
		                        	<img class="icon_img" src="<c:url value="/resources/img/info.png"></c:url>"> 
		                        </i>
		                        <div class="info_modal info_finish display_none">
		                            완료된 스터디로 전환 시 스터디 활동이 일부 제한되며, 자유게시판만 사용가능합니다. <br>
		                            목표를 달성하거나 일정이 모두 완료된 경우에만 전환할 것을 권유드립니다.
		                        </div>
		                    </div>
		                    <c:if test="${st_state ==1}">
			                    <button class="btn_finish">스터디 완료</button>
		                    </c:if>
		                    <c:if test="${st_state ==0}">
		                    	<button class="btn_finish_cancel">스터디 완료 취소</button>
		                    </c:if>
		                </div>
		                <div class="remove_box study_box">
		                    <div class="sb_title">
		                        <h3>스터디 영구 삭제</h3>
		                        <i class="icon_info info_2">
		                         <img class="icon_img" src="<c:url value="/resources/img/info.png"></c:url>"> 
		                        </i>
		                        <div class="info_modal info_delete display_none">
		                            스터디 삭제 시 스터디에올라온 게시글, 인증내역, 일정, 회원정보 등
		                            모든 정보가 함께 삭제되며 해당 스터디에 접근이 불가합니다.
		                        </div>
		                    </div>
		                    	<button class="btn_delete">스터디 삭제</button>
		                </div>
		            </div>
		       	 </div>
		       </div>
			</div>
		</div>
	
					
	
	    <!-- 오른쪽 메뉴 -->
	  <!--  <aside>
	        <div class="right-container">
	            <div class="study_link_container">
	                <div class="circle_now cc">
	                    <div class="now">NOW</div>
	                </div>
	                <div class="circle_star cc">
	                    <img class="star" src="<c:url value="/resources/img/favorite_star_on.png"></c:url>">
	                    
	                </div>
	                <div class="my_study_container">
	                    <div class="my_list_title">
	
	                        <div class="my">MY</div>
	
	                    </div>
	                    <div id="dropdown_list" style="display: none;">
	                        <ul class="dropdown_list_ul">
	                            <li class="dropdown_list_li">
	                                <div class="dropdown_list_contents">
	                                    <p class="dropdown_list_contents_title">정보처리기사 스터디</p>
	                                    <div class="dropdown_list_contents_on_img"></div>
	                                    <div class="dropdown_hr"></div>
	                                </div>
	                            </li>
	                            <li class="dropdown_list_li">
	                                <div class="dropdown_list_contents">
	                                    <p class="dropdown_list_contents_title">정보처리기사 스터디</p>
	                                    <div class="dropdown_list_contents_off_img"></div>
	                                    <div class="dropdown_hr"></div>
	                                </div>
	                            </li>
	                            <li class="dropdown_list_li">
	                                <div class="dropdown_list_contents">
	                                    <p class="dropdown_list_contents_title">정보처리기사 스터디</p>
	                                    <div class="dropdown_list_contents_off_img"></div>
	                                    <div class="dropdown_hr"></div>
	                                </div>
	                            </li>
	                            <li class="dropdown_list_li">
	                                <div class="dropdown_list_contents">
	                                    <p class="dropdown_list_contents_title">정보처리기사 스터디</p>
	                                    <div class="dropdown_list_contents_off_img"></div>
	                                    <div class="dropdown_hr"></div>
	                                </div>
	                            </li>
	                        </ul>
	                    </div>
	                </div>
	            </div>
	        </div>
	        <div class="accessor">
	            <div class="study_title">정보처리기사 스터디</div>
	            <div class="accessor_container">
	                <div class="circle_accessor">
	                    <div class="accessor_on"></div>
	                </div>
	                <div class="study_name">김돌탕</div><span class="your">YOU</span>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">김순연</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">김세영</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">김도현</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">이정현</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">가나다</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">라마바</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">사아나</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">s아나</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">s아나</div>
	            </div>
	            <div class="accessor_container">
	                <div class="circle_accessor"></div>
	                <div class="study_name">s아나</div>
	            </div>
	
	        </div>
	    </aside>
	</div> -->  
</main>

<script>
//icon_info 마우스 hover시 설명창 나타남
function toggleInfo(target){
	$(target).toggleClass("display_none");
}

$(document).ready(function(){
	$(".info_1, .info_2").hover(function(){
		if(this.classList.contains("info_1")){
			toggleInfo(".info_finish");
		}else if(this.classList.contains("info_2")){
			toggleInfo(".info_delete");
		}
	})
})


// 버튼 클릭시 스터디 선택 여부에 따라 confirm창 나타남
function confirmAction(buttonText, action) {
  if (confirm(buttonText)) {
    action();
  } else {
    console.log("작업 취소");
  }
}





//스터디 완료
$(".btn_finish").on("click", function() {
	let obj = {
			st_num: ${st_num}
	}
  confirmAction("완료된 스터디로 전환 시 스터디 활동이 일부 제한되며, 자유게시판만 사용가능합니다. 목표를 달성하거나 일정이 모두 완료된 경우에만 전환할 것을 권유드립니다. 정말 완료하시겠습니까?", function() {
		$.ajax({	
			async:false,
		    type:'POST',
		    data:JSON.stringify(obj),
		    url:"<c:url value='/study/management/study/update/{st_num}'></c:url>",
		    //서버에서 받는 데이터 타입
		    dataType:"json",
		    //서버에서 보내는 데이터 타입
		    contentType:"application/json; charset=UTF-8",
		    success : function(data){
		        console.log(data);
		        
		    	location.replace("<c:url value='/study/management'></c:url>");	  
		  	  alert("스터디가 완료처리 되었습니다.")
		    }
		});
	});
});

//스터디 완료 취소
$(".btn_finish_cancel").on("click", function() {
	let obj = {
		st_num: ${st_num}
	};
	confirmAction("스터디 상태를 복원하시겠습니까?", function() {
		$.ajax({	
			async: false,
			type: 'POST',
			data: JSON.stringify(obj),
			url: "<c:url value='/study/management/study/update/undo/{st_num}'></c:url>",
			dataType: "json",
			contentType: "application/json; charset=UTF-8",
			success: function(data) {
				console.log(data);
				location.replace("<c:url value='/study/management'></c:url>");
				alert("스터디가 복원되었습니다.");
			}
		});
	});
});

// 스터디 삭제 
$(".btn_delete").on("click", function() {
	let obj = {
			st_num: ${st_num}
	}
	
  confirmAction("스터디 삭제 시 스터디에올라온 게시글, 인증내역, 일정, 회원정보 등 모든 정보가 함께 삭제되며 해당 스터디에 접근이 불가합니다. 정말 삭제하시겠습니까?", function() {
		$.ajax({	
			async:false,
		    type:'POST',
		    data:JSON.stringify(obj),
		    url:"<c:url value='/study/management/study/delete/{st_num}'></c:url>",
		    //서버에서 받는 데이터 타입
		    dataType:"json",
		    //서버에서 보내는 데이터 타입
		    contentType:"application/json; charset=UTF-8",
		    success : function(data){
		        console.log(data);
				location.replace("<c:url value='/study/management'></c:url>");
				alert("스터디가 삭제되었습니다.");
		    }
		});
  	});
});


</script>