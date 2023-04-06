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
<link rel="stylesheet" href="<c:url value ='/resources/css/mypage/mypost_post.css?after'></c:url>">
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
						<a href="./mypage.html" class="list_item">마이페이지 홈</a>
						<a href="./edit_info.html" class="list_item">개인정보 수정</a>
						<a href="#" class="list_item">예약 관리</a>
						<a href="./mystudy.html" class="list_item">스터디 관리</a>
						<a href="./mypost.html" class="list_item">작성글 관리</a>
					</nav>
				</aside>
				
				 <section>
            <!-- 탭 -->
            <div class="tab-container">
            	<a href="<c:url value='/mypage/mypost_post'></c:url>"  class="tab selected_tab tab1"><div>나의 게시글</div></a>
	            <a href="<c:url value='/mypage/mypost_recruit'></c:url>" class="tab unselected_tab tab2"><div>나의 모집글</div></a>
	            <a href="<c:url value='/mypage/mypost_scrap'></c:url>"  class="tab unselected_tab tab3"><div>나의 스크랩</div></a>
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

                    <div class="tab_content">
                      <!-- 나의 게시글 -->
                      <div class="table_area" id="tabs_1">
                      <!-- <div class="tab-content_tabel_area 1"> -->
                        <table class="border_box">
                          <thead>
                            <tr class="board_title_list">
                              <td class="title_list_item">번호</td>
                              <td class="title_list_item">스터디명</td>
                              <td class="title_list_item">제목</td>
                              <td class="title_list_item">작성자</td>
                              <td class="title_list_item">작성일</td>
                            </tr>
                          </thead>
                          
                          <tbody>
                            <tr class="board_list">
                              <td>24</td>
                              <td>프론트엔트 공부해요</td>
                              <td class="post_title">리액트 처음부터 함께 배워요</td>
                              <td>프론트 마스터</td>
                              <td>2023.02.28</td>
                            </tr>                       

                          </tbody>
                        </table>
                      </div>

                    <!-- 페이지 이동 -->
                    <div class="page_area">
                      </div>
                        <div class="page_box clearfix">
                          <i class="btn_prev"></i>
                          <span class="page_num selected">1</span>
                          <span class="page_num">2</span>
                          <span class="page_num">3</span>
                          <i class="btn_next"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>  
          </section> 
			</div>
		</main>

	</div>
<script>	
	$('#edit_info').submit(function(){
		event.preventDefault(); // submit 이벤트 막기
		
		if($("#profile_img").val() != ''){	
			
			var allowedExtensions = ["jpg", "jpeg", "png", "gif"];
			var fileName = $("#profile_img").val();
			var fileExtension = "";
			
			// 파일 이름에서 확장자 추출
	        var i = fileName.lastIndexOf('.');
	        if (i > 0) {
	            fileExtension = fileName.substring(i+1);
	            
		    	// 이미지 파일이 아닌 경우
		        if ($.inArray(fileExtension.toLowerCase(), allowedExtensions) == -1) {
		            alert("이미지 파일 형식이 아닙니다.");
		            return false;
		        }else{	    	 
					alert('이미지가 변경되었습니다.');
					$(this).unbind('submit').submit(); // submit 이벤트 다시 실행	        	
		        }
	        }
		}else{
			alert('파일을 선택해주세요.');
			return false;			
		}
	});


</script>

</body>
</html>