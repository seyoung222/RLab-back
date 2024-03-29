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
<link rel="stylesheet" href="<c:url value ='/resources/css/mypage/mypage.css?after'></c:url>">
<link rel="stylesheet" href="<c:url value ='/resources/css/mypage/mypage_common.css?after'></c:url>">
<title>마이 페이지</title>
</head>
<body>
    <!-- pet_store_popup -->
    <div class="pet_store_popup_container display_none">
      <div class="pet_store_popup_box">
        <i class="btn_remove"></i>
        <div class="pet_store_content">
          <div class="popup_title">
            <i class="icon_store"></i> 펫 스토어
            <button class="btn_return">펫 돌려보내기</button>
          </div>
          <div class="pets_container">
          	<c:forEach	items="${petList}" var="pl">
	            <div class="pet_box">
				<input type="hidden" value="${pl.pe_num}" class="petnum">
	            <c:if test="${files.size() != 0}">
		            <c:forEach items="${petFile}" var="pf">
		            	  <c:if test="${pf.ev_level == pl.pe_final_level}">
		            	 	<img src="<c:url value='/resources/img${pf.ev_img}'></c:url>" class="pet_img">
		            	  </c:if>
		            </c:forEach>
		       
	            </c:if>
	              <div class="pet_title">
	                <div class="pet_name"><h2>${pl.pe_name}</h2></div>
	                <div class="pet_level">Lv.${pl.pe_final_level}</div>
	              </div>
	              <div class="pet_reward"><p>보상: </p><p>${pl.pe_prize}</p><i class="icon_reward"></i></div>
	              <button class="btn_bring" id="pet_1">데려오기</button>
	            </div>
            </c:forEach>
          </div>
        </div>
      </div>
      
    </div>
    <!-- background -->
    <div class="background_bbls">
      <div class="big_bbls">
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
      </div>
      <div class="small_bbls">
        <div class="bubble"></div>
        <div class="bubble"></div>
      </div>
    </div>
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
              <a href="<c:url value='/mypage/mystudy_favorite'></c:url>" class="list_item">스터디 관리</a>
              <a href="<c:url value='/mypage/mypost_post'></c:url>" class="list_item">작성글 관리</a>
            </nav>
          </aside>

          <div class="articles">
            <!-- article_top(이용시간, 펫 창) -->
            <article class="article_top">
              <!-- used_hours_container -->
              <div class="article_box" id="used_hours_container">
               
                
                <div class="user_info">
                 <a href="<c:url value='/mypage'></c:url>" class="icon_profile">
	    			<c:if test="${user.me_profile == null}">
	    				<img class="mypage_img" src="<c:url value='/resources/img/user.png'></c:url>" width="auto" height="110">
	    				<span class="blind">마이페이지</span>
	    			</c:if>
	    			
	    			<c:if test="${user.me_profile != null}">
		    			<img class="mypage_img" src="<c:url value='/download${user.me_profile}'></c:url>" width="auto" height="110">
		    			<span class="blind">마이페이지</span>
	    			</c:if>
 		    	</a>
                 <div id="user_info_container">
                  <span><strong>"${user.me_name}"</strong> 님 안녕하세요</span>
                  <div class="my_point">
                    <h2 class="title_point">적립 포인트 : </h2>                  
                    <div class="point_texts">
                      <!-- <p class="title_point">Point</p> -->
                      <div class="num_point">
                        <span class="p_num">${user.me_point}</span>
                        <span class="p_point">P</span>
                      </div>
                    </div>
                  </div>
                </div>  
                </div>
                <!-- 이용 시간 -->
                <!-- 좌석 예약 정보가 없으면... -->
                <c:if test="${res == null}">
                	<div id="used_hours">
		            	<div class="title">
		                	<h2 class="property_title">이용시간</h2>
		                    <p class="info time_info">
		                    	<strong>좌석예약 정보가 없습니다.</strong>
		                    	<a class="res_btn" href="<c:url value='/reservation'></c:url>">이용권 예약</a>
		                    </p>
		       			</div>
		       			
		        		<div class="gauge gauge_used_hours" style= "background-color:#c1c1c1"></div>
		        	</div>
                </c:if>
                <!-- 좌석 예약 정보가 있으면... -->
				<c:if test="${res != null}">
		        	<div id="used_hours">
		            	<div class="title">
		                	<h2 class="property_title">이용시간</h2>
		                    <p class="info time_info">
		                      <strong>~ ${res.re_valid_time_str2}</strong>
		                    </p>
		        		</div>
		        		
	                	<div class="gauge gauge_used_hours">
	                		<div class="gauge_colored use_time_colored"></div>
	               		</div>
		          	</div>
	            </c:if>
				<!-- 펫 경험치 -->
				<!-- 키우고 있는 펫이 없으면... -->
				<c:if test="${myPet == null}">
					 <div id="pet_exp">
	                  <div class="title">
	                    <h2 class="property_title">펫 경험치</h2>
	                    <p class="info exp_info"><strong>키우고 있는 펫이 없습니다.</strong> </p>
	                  </div>
	                  <div class="gauge gauge_pet_exp">
		                <!-- 게이지가 회색으로 차게 된다 -->
	                    <div class="gauge_colored" style= "background-color:#c1c1c1"></div>
	                  </div>
	                </div>
				</c:if>
				<!-- 키우고 있는 펫이 있으면... -->
				<c:if test="${myPet != null}">
					<!-- 현재 경험치(gr_exp)가 최종 레벨 경험치(ex_experience)에 도달하면... -->
	                <c:if test="${myPet.gr_exp == myPet.ex_experience}">
		                <div id="pet_exp" class="what1">
		                  <div class="title">
		                    <h2 class="property_title">펫 경험치</h2>
		                    	<p class="info exp_info"><strong> ${currentExp}</strong>exp / ${levelUpExp}&nbsp;exp</p>
		                  </div>
		                  <div class="gauge gauge_pet_exp">
		                  	<!-- 최종 레벨에 도달했으므로 게이지가 100%로 다 차게 된다 -->
		                    <div class="gauge_colored" style= "background-color: yellow"></div>
		                  </div>
		                </div>
	                </c:if>
	                <!-- 현재 경험치(gr_exp)가 최종 레벨 경험치(ex_experience)와 같지 않다면... -->
	                <c:if test="${myPet.gr_exp != myPet.ex_experience}">
		                <div id="pet_exp" class="what2">
		                  <div class="title">
		                    <h2 class="property_title">펫 경험치</h2>
		                    <p class="info exp_info"><strong>${currentExp}</strong>exp / ${levelUpExp}&nbsp;exp</p>
		                  </div>
		                  <div class="gauge gauge_pet_exp">
		                    <div class="gauge_colored pet_ex_colored"></div>
		                  </div>
		                </div>
		            </c:if>
	          	</c:if>
              </div>
              <!-- pet_container -->
              <div class="article_box pet_container">
             	 <c:if test="${myPet == null}">
	                <div class="pet_window">
	                  <div class="pet_box">
		                  <img src="" alt="" class="pet_talk" />
		                  <img src="<c:url value="/resources/img/rlab_logo.png"></c:url>" alt="펫" class="pet" width="auto" height="170" />
	                  </div>
	                </div>
	                <div class="pet_description">
	                  <div class="pet_info_container" id="pet_wait">
	 					<span class="txt_new_pet">
	 						<div class="pet_phrases1">펫이 당신을 기다리고 있어요!<br></div>
	 						<div class="pet_phrases2">
	 							펫스토어에서 펫 데려오기 <i class="pointer_box"><img alt="pointer" src="<c:url value="/resources/img/pointer.png"></c:url>"width="auto" height="20"></i>
	 						</div>
	 					</span>
	                  </div>
	                    <div id="pet_store_container">
	                      <i class="icon_store"></i> 펫 스토어
	                    </div>
	                </div>
	              </c:if>
	              <c:if test="${myPet != null }">
	                <div class="pet_window">
		                <div class="pet_box">
		                  <img src="" alt="" class="pet_talk" />
		                  <img src="<c:url value="/resources/img${myPet.ev_img}"></c:url>" alt="펫" class="pet" width="auto" height="170"/>
		                </div>
	                </div>
	                <div class="pet_description">
	                  <div class="pet_info_container">
	                    <div class="this_pet">
	                      <h2 class="pet_name">${myPet.pe_name}</h2>
	                      <div class="pet_reward">
	                        ㄴ보상 : ${myPet.pe_prize} <i class="icon_reward"></i>
	                      </div>
	                    </div>
	                    <div class="pet_level">Lv. ${myPet.gr_level}</div>
	                  </div>
	                  	<c:if test="${myPet.gr_exp == myPet.ex_experience}">		                    
			                <div id="pet_getPrize_container" class="pet_getPrize_container">
		                      <i class="icon_getPrize"></i>펫 보상받기
		                    </div>
		                </c:if>
		                <c:if test="${myPet.gr_exp != myPet.ex_experience}">		
		                    <div id="pet_store_container">
		                      <i class="icon_store"></i> 펫 스토어
		                    </div>
	                    </c:if>
	                    
	                </div>
	              </c:if>
              </div>
           
            </article>
            
            <article class="article_second">
            <h3 class="book_head_title">나의 예약</h3>
              <div class="dday_container">
                <ul class="list_dday">
                <!-- 좌석, 캐비넷 둘다 예약이 있을 때 -->
                 <c:if test="${mySeat != null && myLocker != null}">
                    <div class="item_dday">
                    	<h4>좌석 : </h4>
	                    <h4>${mySeat.branchVO.br_name}</h4>
	                    <div class="book_title">${mySeat.ki_name}&nbsp;<h4>${mySeat.se_name}번</h4></div>
                  	</div>
                    <div class="item_dday">
                    	<h4>사물함 : </h4>
                    	<h4>${myLocker.branchVO.br_name}</h4>
                       	<div class="book_title">${myLocker.ki_name}&nbsp;<h4>${myLocker.se_name}번</h4></div>
                    </div>
                  
                  </c:if>
                  <!-- 좌석 예약만 있고 캐비넷 예약이 없을 때 -->
                  <c:if test="${mySeat != null && myLocker == null}">
                    <div class="book_info">
	                    <h4>${mySeat.branchVO.br_name}</h4>
	                    <div class="book_title">${mySeat.ki_name}&nbsp;<h4>${mySeat.se_name}번</h4></div>
                  		</div>
                  </c:if>
                  <!-- 좌석 예약이 없고 캐비넷 예약만 있을 때 -->
                   <c:if test="${mySeat == null && myLocker != null}">
                    <div class="book_info">
                    	<h4>${myLocker.branchVO.br_name}</h4>
                       	<div class="book_title">${myLocker.ki_name}&nbsp;<h4>${myLocker.se_name}번</h4></div>
                    </div>
                  </c:if> 
                 
                  <!-- 좌석 예약, 캐비넷 예약 둘다 없을 때 -->
                   <c:if test="${mySeat == null && myLocker == null}">
                    <div class="book_info">
	                    <h4>예약 정보가 없습니다.</h4>
                  		</div>
                  </c:if>
                </ul>
              </div>
              <a href="<c:url value='/mypage/myres_book'></c:url>">
              	<p class="plus_dday">더보기 +</p>
              </a>
            </article>

            <!-- article_third(나의 스터디, 나의 스크랩) -->
            <article class="article_third">
              <!-- my_study_container -->
              <div class="article_box my_study_container">
                <div class="title_background"></div>
                <div class="title_container">
                  <h2 class="property_title">나의 스터디</h2>
                  <a href="<c:url value='/mypage/mystudy_progress'></c:url>">
                    <p class="show_plus">더보기+</p>
                  </a>
                </div>
                <ul class="list_container">
	                <c:if test="${myStudyList == null || myStudyList.size() == 0}">
	                  <div class="noPostMsg">
	                  	<p>참여중인 스터디가 없습니다.</p>
	                  </div>
	                </c:if>
	                 <c:forEach items="${myStudyList}" var="mst" varStatus="vs">
	                      	<c:if test="${mst.st_image == null}">
		                 		<a class="link_study" onclick="location.href='<c:url value='/study/${mst.st_num}'/>';">
	                   				<li class="list_item">
			                      		<i class="icon_study"><img src="<c:url value='/resources/img/recruit_thumb.png'></c:url>" width="auto" height="51"></i>
			                      		${mst.st_name}
			                    	</li>
					            </a>
		  		    		</c:if>
		  		    		<c:if test="${mst.st_image != null}">
			  		    		<a class="link_study" onclick="location.href='<c:url value='/study/${mst.st_num}'/>';">
			  		    			<li class="list_item">
			                      		<i class="icon_study"><img src="<c:url value='/download/study/${mst.st_image}'></c:url>" width="auto" height="51"></i>
					                     ${mst.st_name} 		
				  		    		</li>
			  		    		</a>
		  		    		</c:if>
                  </c:forEach>
                </ul>
              </div>
              <!-- my_scrab_container -->
              <div class="article_box my_scrab_container">
                <div class="title_background"></div>
                <div class="title_container">
                  <h2 class="property_title">나의 스크랩</h2>
                  <a href="<c:url value='/mypage/mypost_scrap'></c:url>">
                    <p class="show_plus">더보기+</p>
                  </a>
                </div>
                
                <ul class="list_container scrap_list">
                  <!-- 스크랩한 게시글 상세로 이동 -->
                  <c:if test="${myScrapList == null || myScrapList.size() == 0}">
	                  <div class="noPostMsg">
	                  	<p>스크랩한 게시물이 없습니다.</p>
	                  </div>
                  </c:if>
                  <c:forEach items="${myScrapList}" var="ms" varStatus="vs">
	                  <a onclick="location.href='<c:url value='/board/detail/${ms.bo_st_num}/${ms.bo_num}'/>';">
	                    <li class="list_item">
	                      <i class="icon_scrab"></i>
	                      <div class="title_scrab">[${ms.st_name}]</div>
	                      <p class="content_scrab">${ms.bo_title}</p>
	                    </li>
	                  </a>
                  </c:forEach>
                  
                </ul>
              </div>
            </article>
          </div>
        </div>
      </main>

    </div>
    <script> <!-- 펫 기능 -->
    const userId = '${user.me_id}';
    let hadPet = '${myPet}';
    let petNum =  '${myPet.gr_pe_num}'
    
	 // pet_store 모달 열기
	    $(document).on('click', '#pet_store_container', function(e){
	    	console.log('click');
	    	$('.pet_store_popup_container').css('display','flex');
	    });
	
	    // pet_store 모달 닫기
	    $(document).on('click', '.btn_remove', function(e){
	    	console.log('click');
	    	$('.pet_store_popup_container').css('display','none');
	    });
	    
	// 펫 데려오기
	$(document).ready(function() {    
		$('.btn_bring').on('click', function() {
			choosePet($(this));
		});
		function choosePet(el){
			let gr_pe_num = el.parents('.pet_box').find('.petnum').val();
			let ev_num = el.parents('.pet_box').find('.pet_img').data('ev_num');
			//갖고있는 펫이 있다면 안내창
		   if (hadPet.length > 0) {
		        alert('새로운 펫을 데려오려면 펫 돌려보내기를 하세요.');
		        return;
		    }
			
			let obj = {
			    gr_me_id: userId,
			    gr_pe_num: gr_pe_num,
			    gr_ev_num: ev_num
			};
		 	
			$.ajax({
			    async: true,
			    type: 'POST',
			    data: JSON.stringify(obj),
			    url: '<c:url value="/choosePet" />',
			    dataType: 'json',
			    contentType: 'application/json; charset=UTF-8',
			    success: function(data) {
			    	alert('펫 데려오기에 성공하였습니다.');
			    	location.reload();		
			      },
			      error: function(error) {
			    	  console.log(error)
			        alert('펫 데려오기에 실패하였습니다. 다시 시도해주세요');
			      }
			    
			});
		}
	});
    
	// 펫 돌려보내기
	$(document).ready(function() {    
		$('.btn_return').on('click', function() {
			deletePet($(this));
		});
		function deletePet(el){
			let gr_pe_num = el.parents('.pet_box').find('.petnum').val();
			let ev_num = el.parents('.pet_box').find('.pet_img').data('ev_num');
			
			
			if(hadPet.length == 0){
				alert('돌려보낼 펫이 없습니다. 펫을 데려와주세요.');
				return
			}
			
			if (hadPet.length > 0) {
			    let confirmMsg = '펫을 돌려보내면 펫은 완전히 사라집니다. 그래도 돌려보내시겠습니까?';
			    //아니요를 누르면 return , 예를 누르면 ajax진행
			    if (!confirm(confirmMsg)) {
			      return;
			    }
			  }
					
			let obj = {
			    gr_me_id: userId,
			    gr_pe_num: gr_pe_num,
			    gr_ev_num: ev_num
			};
		 	
			$.ajax({
			    async: true,
			    type: 'POST',
			    data: JSON.stringify(obj),
			    url: '<c:url value="/deletePet" />',
			    dataType: 'json',
			    contentType: 'application/json; charset=UTF-8',
			    success: function(data) {
			    	alert('펫 돌려보내기에 성공하였습니다.');
			    	location.reload();		
			      },
			      error: function(error) {
			    	  console.log(error)
			        alert('펫 돌려보내기에 실패하였습니다. 다시 시도해주세요');
			      }
			    
			});
		}
	});
	
	// 펫 보상받기
	$(document).ready(function() {      
		$('.pet_getPrize_container').on('click', function() {
			getPrize($(this));
		});
		function getPrize(el) {
			  let gr_pe_num = el.parents('.pet_box').find('.petnum').val();

			  if (hadPet.length > 0) {
			    let confirmMessage = '펫 보상을 받으시겠습니까?';
			    //아니요를 누르면 return , 예를 누르면 ajax진행
			    if (!confirm(confirmMessage)) {
			      return;
			    }

			  let obj = {
				gr_me_id: userId,
			    gr_pe_num: petNum
			  };

			  $.ajax({
			    async: true,
			    type: 'POST',
			    data: JSON.stringify(obj),
			    url: '<c:url value="/getPrize" />',
			    dataType: 'json',
			    contentType: 'application/json; charset=UTF-8',
			    success: function(data) {
			      alert('보상받기에 성공하였습니다.');
			      location.reload();
			    },
			    error: function(error) {
			      console.log(error)
			      alert('보상받기에 실패하였습니다. 다시 시도해주세요');
			    }
			  });
			}
		}
		});
</script>
<script> <!-- 내 정보란 -->
	// 이용시간 게이지 업데이트 
	function updateGauge(resStart, resValid, now){
		// 현재 시간이 예약 시작 시간보다 크거나 같을 때...
		if(now >= resStart){
			var elapsedTime = now.getTime() - resStart.getTime(); // 경과 시간 = 현재 시간 - 시작 시간 
			var totalTime = resValid.getTime() - resStart.getTime(); // 전체 시간 = 종료 시간 - 시작 시간 
			var percentage = elapsedTime / totalTime * 100; // 백분율 = 경과 시간 / 전체 시간 * 100 
			
			// 게이지의 width 
			$('.use_time_colored').width(percentage + '%');
		}
	}
	$(document).ready(function(){
		var now = new Date();
		
		// 페이지 진입 시 예약권이 있으면 시간을 계산함
		if(${res != null}){
	   		var resStart = '${res.re_start_time}';
	   		var resValid = '${res.re_valid_time}';
	   		
	   		intervalId = setInterval(function(){
	   			
	   			$.ajax({
	   				url: '<c:url value="/mypage/timeGauge" />',
	   				type: "GET",
	   				success: function(data){
	   					console.log(1);
	   					//페이지에 있는 도중 예약권이 다 되면 새로고침하며 이용권 만료 메세지 보여줌
	   					if(data == ''){
	   						clearInterval(intervalId);
	   						location.href = '<c:url value="/mypage"></c:url>';
	   						return;
	   					}
	   					resStart = new Date(data.re_start_time); // 예약 시작 시간 
	   					resValid = new Date(data.re_valid_time); // 예약 종료 시간 
	   					// updateGauage 호출 
	   					updateGauge(resStart, resValid, now);
	   				}
	   			});
	   		}, 1000); // 1초마다 업데이트
	  		}
	});
	let intervalId;	// setInterval()의 반환값 
    
    // 펫 경험치에 따른 게이지 변화
  	$(document).ready(function(){
  		// 나의 펫이 존재하면...
  		if(${myPet != null}){
	        var gaugeWidth = $('.pet_ex_colored').width(); // 게이지의 너비
	        let currentExp = '${currentExp}'; // 현재 경험치
	        let levelUpExp = '${levelUpExp}'; // 레벨 업 경험치
	        var ratio = currentExp / levelUpExp; // 현재 경험치 / 레벨 업 경험치
	        gaugeWidth = ratio * 100 + '%'; // 백분율로 계산한 값 = 게이지의 너비
	
	        // 실제 게이지의 너비를 gaugeWidth로 바꿔준다  
	        $('.gauge_colored').css("width",gaugeWidth);
  		}
    });
    
	// pet_store 모달 열기
	   $(document).on('click', '#pet_store_container', function(e){
	   	console.log('click');
	   	$('.pet_store_popup_container').css('display','flex');
	   })
	
    // pet_store 모달 닫기
    $(document).on('click', '.btn_remove', function(e){
    	console.log('click');
    	$('.pet_store_popup_container').css('display','none');
    })
    </script>
</body>
</html> 