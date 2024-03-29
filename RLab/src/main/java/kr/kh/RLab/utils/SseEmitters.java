package kr.kh.RLab.utils;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.BiConsumer;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;


/*
 * 서버에서 클라이언트로 이벤트를 전송하는 표준기술임 
 */
@Component
public class SseEmitters {
	private static final Logger logger = LoggerFactory.getLogger(SseEmitters.class);
	
	// 연결된 사용자의 이벤트 발송기 및 세션 정보를 저장
	private final Map<String, UserSessionInfo> emitters = new ConcurrentHashMap<>();
	/*
	// 새 사용자를 추가하고 이벤트 발송기와 세션 만료 시간 설정
	public void add(String id, SseEmitter emitter, LocalDateTime sessionExpiryTime) {
		UserSessionInfo userSessionInfo = new UserSessionInfo(emitter, sessionExpiryTime);
		this.emitters.put(id, userSessionInfo);

		emitter.onCompletion(() -> {
			this.emitters.remove(id);
		});

		emitter.onTimeout(() -> {
			emitter.complete();
		});
	}*/
    // 모든 사용자에 대해 주어진 작업을 수행
	public void forEach(BiConsumer<? super String, ? super UserSessionInfo> action) {
		emitters.forEach(action);
	}
    // 사용자가 연결되어 있는지 확인
	public boolean isUserConnected(String id) {
		return emitters.containsKey(id);
	}
	// 사용자 세션 정보를 저장하는 클래스
	public static class UserSessionInfo {
		private final SseEmitter emitter;
		private final LocalDateTime sessionExpiryTime;

		public UserSessionInfo(SseEmitter emitter, LocalDateTime sessionExpiryTime) {
			this.emitter = emitter;
			this.sessionExpiryTime = sessionExpiryTime;
		}

		public SseEmitter getEmitter() {
			return emitter;
		}

		public LocalDateTime getSessionExpiryTime() {
			return sessionExpiryTime;
		}

		public LocalDateTime getLastActivity() {
			return sessionExpiryTime;
		}
	}
  
	// 이벤트 발송기를 사용하여 새 사용자 추가
	public void add(String id, SseEmitter emitter, LocalDateTime sessionExpiryTime, HttpSession session) {
		
		if(id == null || id.length() == 0)
			return;
		if(emitters.containsKey(id))
			return;
	    if (emitter != null) {
	        UserSessionInfo userSessionInfo = new UserSessionInfo(emitter, sessionExpiryTime);
	        this.emitters.put(id, userSessionInfo);
	        //session.setAttribute("emitter", true);
	        System.out.println("sseConnect : " + id);
	        emitter.onCompletion(() -> {
	            this.emitters.remove(id);
	            //session.removeAttribute("emitter");
	            System.out.println("ssecomplete : " + id);
	        });

	        emitter.onTimeout(() -> {
	            emitter.complete();
	            System.out.println("ssetimeout : " + id);
	        });
	    }
	}
    // 사용자 제거
	public void remove(String id) {
	    if (id != null) {
	        this.emitters.remove(id);
	    }
	}
	// 특정 사용자에게 이벤트 데이터를 전송
	public void send(String eventName, Object eventData, String targetId, HttpSession session) {
		System.out.println("emitter send : "+emitters.size());
		System.out.println(emitters);
		if(targetId == null || targetId.length() == 0) {
			return;
		}
		/*if(session.getAttribute("emitter") == null) {
			System.out.println("중단: session.getAttribute(\"emitter\") == null");
			return ;
		}*/
		emitters.forEach((id, userSessionInfo) -> {
			System.out.println(eventName+" : "+id);
	        if (id != null && userSessionInfo != null && userSessionInfo.getEmitter() != null) {
	            try {
	                if (id.equals(targetId)) {
	                	System.out.println(eventName + " : " +id);
	                    userSessionInfo.getEmitter().send(SseEmitter.event().name(eventName).data(eventData));
	                    System.out.println("전송완료");
	                }
	            } catch (Exception e) {
	            	System.out.println("sseEmitter 에러 발생");
	                logger.error("Error sending count event to user {}", id, e);
	            }
	        }
	    });
	}
	
	public List<String> getOnlineUserIds() {
	    return new ArrayList<>(emitters.keySet());
	}
	public SseEmitter getEmitter(String id) {
		UserSessionInfo usi = emitters.get(id); 
		return usi == null ? null : usi.getEmitter();
	}
}