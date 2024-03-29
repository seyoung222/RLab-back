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
<link rel="stylesheet" href="<c:url value ='/resources/css/mypage/edit_user.css'></c:url>">
<title>개인정보 수정</title>
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
		              <a href="<c:url value='/mypage/mystudy_favorite'></c:url>" class="list_item">스터디 관리</a>
		              <a href="<c:url value='/mypage/mypost_post'></c:url>" class="list_item">작성글 관리</a>
					</nav>
				</aside>

				<div class="form_container">
					<form action="<c:url value ='/mypage/user'></c:url>" method="post" id="edit_info" enctype="multipart/form-data">
						<h1>개인정보 수정</h1>
						<div class="input_container">
							<label for="profile_img">프로필 사진 수정</label>
							<div class="item_container">
								<div class="input_box">
									<input type="file" class="input_window" id="profile_img" name="file" value="${user.me_profile}" >
								</div>
							</div>
						</div>
												
						<div class="input_container">
							<label for="nick_name">닉네임 수정</label>
							<div class="item_container">
								<div class="input_box">
									<input type="text" class="input_window" id="nick_name" name="me_name" value="${user.me_name}" placeholder="새 닉네임 입력">
								</div>
								<input type="button" class="check_btn check_name" value="중복 확인">
							</div>
						</div>

						<div class="input_container">
							<label for="pw_new">비밀번호 수정</label>
							<div class="input_box">
								<input type="password" class="input_window" id="pw_new" name="me_pw" placeholder="새 비밀번호 입력">
							</div>
						</div>

						<div class="input_container">
							<label for="pw_new_check">새 비밀번호 확인</label>
							<div class="input_box">
								<input type="password" class="input_window" id="pw_new_check" name="me_pw2"  placeholder="새 비밀번호 확인">
							</div>
						</div>

						<div class="input_container">
							<label for="email">이메일</label>
							<div class="item_container">
								<div class="input_box">
									<input type="email" class="input_window" id="email" name="me_email" value="${user.me_email}" placeholder="000000@naver.com">
								</div>
								<input type="button" id="mail_send_btn" class="check_btn check_mail" value="이메일 인증">
							</div>
						</div>
						
						<div class="input_container">
							<label for="email">이메일 인증</label>
							<div class="item_container">
								<div class="input_box">
									<input class="mail_check_input input_window" maxlength="6" placeholder="인증번호 6자리를 입력해주세요!">
								</div>
								<input type="button" id="verify_code_btn" class="check_btn check_mail" value="인증번호 확인">
							</div>
						</div>
						
						<div class="submit_container">
							<input type="submit" value="수정하기" id="submit_btn" class="submit_btn">
						</div>
					</form>

				</div>
			</div>


		</main>

	</div>
<script>
	$('#edit_info').submit(function(){
		event.preventDefault(); // submit 이벤트 막기
		var modified = false;
		
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
		        	return;
		        }else{	 
		        	modified = true;
		        }	        	
	        }
		}
		  // 닉네임 변경 여부 확인
		  if ($("#nick_name").val() != '${user.me_name}') {

		    modified = true;
		  }
		  
		  // 비밀번호 변경 여부 확인
		  if ($("#pw_new").val() != '') {
		    modified = true;
		  }
		  
		// 이메일 변경 여부 확인
		  if ($("#email").val() != '${user.me_email}') {
		    modified = true;
		  }
		  
		  if (modified) {
		    alert('수정이 완료되었습니다.');
		    $(this).unbind('submit').submit();
		  } else {
		    alert('수정사항이 없습니다.');
		    return false;
		  }
		

	});

	$("#edit_info").validate({
		// 유효성 검사 규칙
		rules : {
			me_name : {
				//required : true,
				regex : /^[ㄱ-ㅎ가-힣a-zA-Z0-9]{2,9}$/
			},
			me_pw : {
				//required : true,
				regex : /^[a-zA-Z0-9!@#]{8,19}$/
			},
			me_pw2 : {
				equalTo : pw_new
			},
			me_email : {
				//required : true,
				email : true
			}
		},
		
		// 유효성 검사 메세지
		messages : {
			me_name : {
				required : '필수항목 입니다',
				regex : '닉네임은 한글,영어,숫자를 이용하여 2-10자 까지 가능합니다'
			},
			me_pw : {
				required : '필수항목 입니다',
				regex : '비밀번호는 영문, 숫자, !@#를 이용하여 8-20자 까지 가능합니다'
			},
			me_pw2 : {
				equalTo : '비밀번호가 일치하지 않습니다'
			},
			me_email : {
				required : '필수항목 입니다',
				email : '이메일 형식이 아닙니다'
			}	
		},
		submitHandler: function(form) {
			if(!nameCheck){
				alert('닉네임 중복체크를 하세요.');
				return false;
			}
			if(!emailCheck){
				alert('이메일 인증 하세요.');
				return false;
			}
			return true;
		}
	});

$.validator.addMethod("regex", function(value, element, regexp) {
	var re = new RegExp(regexp);
	return this.optional(element) || re.test(value);
}, "Please check your input.");

$('[name= me_name]').change(function(){
	nameCheck = false;
});
$('#verify_code_btn').change(function(){
	emailCheck = false;
});

/* 닉네임 체크 */
$('.check_name').click(function(){
	let me_name = $('[name = me_name]').val();
	let obj = {
			me_name : me_name
	}
	$.ajax({
		async:true,
		type:'POST',
		data: JSON.stringify(obj),
		url: '<c:url value="/check/name"></c:url>',
		dataType:"json",
		contentType:"application/json; charset=UTF-8",
		success : function(data){
		    if(data.res){
		    	alert('사용 가능한 닉네임 입니다.');
		    	nameCheck = true;
		    }else{
		    	alert('사용 불가능한 닉네임 입니다.')
		    }
		},
		error : function(a,b,c){
			
		}
	});
});
$('[name= me_name]').change(function(){
	nameCheck = false;
});
let nameCheck = true; 


/* 이메일인증 */
 $('#mail_send_btn').on('click', function() {
    var email = $('#email').val();
    $.post('<c:url value="/sendEmail"/>', {email: email}, function(response) {
        alert(response);
        $('.mail_check_input').prop('disabled', false);
    });
});
$('#verify_code_btn').on('click', function () {
    var verificationCode = $('.mail_check_input').val();
    if (!verificationCode) {
        alert('인증번호를 입력해주세요.');
        return false;
    }
    $.ajax({
        url: '<c:url value="/check"/>',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            verificationCode: verificationCode
        }),
        success: function (response) {
            if (response) {
                alert('인증번호 확인이 완료되었습니다.');
            } else {
                alert('인증번호가 일치하지 않습니다.');
            }
        },
        error: function () {
            alert('인증번호 확인 중 오류가 발생했습니다.');
        }
    });
});

</script>
</body>
</html>