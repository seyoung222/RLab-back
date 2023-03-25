<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="<c:url value='/resources/css/board/insertBoard.css'></c:url>">
<link href="<c:url value='/resources/css/summernote-lite.min.css'></c:url>" rel="stylesheet">
<script src="<c:url value='/resources/js/summernote-lite.min.js'></c:url>"></script>
<style>
    .note-editable {
        background-color: white;
    }
</style>
<div class="left_menu_container_top" style="margin-left: 118px">
    <div class="left_menu_container">
        <nav class="left_menu">
            <a href="study_basic.html" class="list_item">스터디홈</a>
            <a href="#" class="list_item">스터디 달력</a>
            <a href="to_do_list.html" class="list_item">투두 리스트</a>
            <a href="Daily Mission.html" class="list_item">데일리 미션</a>
            <a href="certification_board.html" class="list_item">인증 게시판</a>
            <a href="#" class="list_item">자유 게시판</a>
            <a href="#" class="list_item">스터디 관리</a>
            <a href="#" class="leave">탈퇴하기</a>
        </nav>
    </div>
</div>
<div id="main_container" style="width: 800px;margin-left: 630px;">
			   
              <div class="main_title"> 
              </div> 
              <div class="temporary_storage_box"> 
			    <button class="call_temporary_storage" id="openModal">임시저장 불러오기
			      <span>|</span>
			      <span>1</span>
			    </button>
			     
			    <!-- Modal -->
			    <div id="temporary-list-modal" class="modal-style" style="display: none;">
			      <h2>임시 게시글<button id="deleteAll">전체 삭제</button></h2>
			      <ul id="itemList">
					        <li>
					            <span class="temp-title" data-title="${temp.te_title}" data-content="${temp.te_content}"></span>
                				<button class="deleteBtn" data-id="${temp.te_num}">삭제</button>
					        </li>
			      </ul>
			      
			    </div>
			    <div id="modal-background" class="modal-background" style="display: none;"></div>
			  </div>
              <form action="<c:url value='/board/update/${bd.bo_num}'></c:url>" method="post"> 
              	 <input type="hidden" name="bo_me_id" value="${memberId}">
                <h2>스터디명</h2> 
                <select id="choose_study" name="bo_st_num">
                <c:forEach var="study" items="${study}">
                		<option value="${study.st_num}" <c:if test="${bd.bo_st_num == study.st_num }">selected</c:if>>${study.st_name}</option>>
           			</c:forEach>
                </select> 
                <h2>제목</h2> 
                <div class="recruit_title_box"> 
                  <input type="text" class="bo_title" name="bo_title" value="${bd.bo_title}"> 
                  <input type="hidden" id="table" name="bo_table" value="자유게시판"/>
                </div> 
                <h2>내용</h2> 
								<textarea id="content" name="bo_content" value="${bd.bo_content}"></textarea>  
              
							<div class="btn_box">
								<button class="ts_btn" type="button">임시저장</button>
								<button class="write_complete_btn" type="submit">수정완료</button>
							</div>
			</form>
</div> 
	<!-- Modal -->
	<div id="temporary-save-modal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background-color: white; border: 1px solid #ccc; padding: 20px; z-index: 9999;">
	    <h2>임시등록이 완료되었습니다.</h2>
	</div>
	<div id="modal-background" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 9998;"></div>

	
<script>
$(document).ready(function() {
    // 임시 저장 버튼 클릭시
	$(".ts_btn").on("click", function() {
		
		 const title = $("input[name='bo_title']").val();
		 const content = $("textarea[name='bo_content']").val();
		 
				 
		    if (!title || !content) {
		        alert('제목과 내용을 모두 입력해주세요.');
		        return;
		    }
		const data = {
				te_title: $("input[name='bo_title']").val(),
			    te_content: $("textarea[name='bo_content']").val(),
			    te_me_id: $("input[name='bo_me_id']").val(),
			    te_st_num: $("#choose_study").val(),
			    te_table: $("input[name='bo_table']").val()
			};
			//ajax
			$.ajax({
			    url: '<c:url value="/temporary/save"/>',
			    method: 'POST',
			    data: JSON.stringify(data), //
			    contentType: 'application/json', //
			    success: function (response) {
			        if (response == "success") {
			            $("#temporary-save-modal").show();
			            $("#modal-background").show();
			        } else {
			            alert('임시저장에 실패하였습니다1');
			        }
			    },
			    error: function () {
			        alert('임시저장에 실패했습니다2');
			    }
			});
    });
	function loadTemporaryList() {
	    $.ajax({
	        url: '<c:url value="/temporary/list"/>',
	        method: 'GET',
	        success: function(response) {
	            // 임시저장 목록을 업데이트
	            $('#itemList').empty(); // 기존 목록 삭제
	            response.forEach(function(temp) {
	                $('#itemList').append('<li><span class="temp-title" data-title="' + temp.te_title + '" data-content="' + temp.te_content + '">' + temp.te_title + '</span><button class="deleteBtn" data-id="' + temp.te_num + '">삭제</button></li>');
	            });
	        },
	        error: function() {
	            alert('임시저장 목록을 가져오는데 실패했습니다.');
	        }
	    });
	}
    //임시저장 불러오기를 클릭했을때
    $("#openModal").click(function () {
	    loadTemporaryList();
	    $("#temporary-list-modal").show();
	    $("#modal-background").show();
	});
    
    	

	$("#modal-background").click(function () {
		$("#temporary-list-modal").hide();
		$("#modal-background").hide();
		  });
    
	// 모달창 외를 클릭했을때 닫기
    $("#modal-background").on("click", function() {
        $("#temporary-save-modal").hide();
        $("#modal-background").hide();
    });
	
  //전체 삭제
    $('#deleteAll').on('click', function() {
        $.ajax({
            url: '<c:url value="/temporary/delete/All" />',
            type: 'POST',
            success: function(response) {
                if (response == "success") {
                    $('#itemList').empty();
                } else {
                    alert('전체 삭제에 실패하였습니다.');
                }
            },
            error: function(error) {
                alert('전체 삭제에 실패하였습니다.');
            }
        });
    });
  //개별 삭제
      $(document).on('click', '.deleteBtn', function() {
      const id = $(this).data('id');
    
    	$.ajax({
        url: '<c:url value="/temporary/delete/' + id + '" />',
        type: 'POST',
        success: function(response) {
            loadTemporaryList();
        },
        error: function(error) {
            alert('삭제 실패');
        }
    });
});
	
    $('#itemList').on('click', '.temp-title', function() {
        const title = $(this).data('title');
        const content = $(this).data('content');

    
        $('input[name=bo_title]').val(title);
        $('#content').summernote('code', content);

        
        $("#temporary-list-modal").hide();
        $("#modal-background").hide();
    });
    
  
});
    $('form').submit(function() {
        let title = $('[name=bo_title]').val();
        let content = $('[name=bo_content]').val();
        if (title.trim().length == 0) {
            alert('제목을 입력하세요.');
            return false;
        }
        if (content.trim().length == 0) {
            alert('내용을 입력하세요.');
            return false;
        }
    })

    $('#content').summernote({
        tabsize: 2,
        height: 300,
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ]
    });
</script>