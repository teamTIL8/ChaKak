package com.chakak.controller;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.chakak.domain.Notice;
import com.chakak.service.NoticeService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notice")

public class NoticeViewController {

	private final NoticeService service;

	// 공지사항 목록
	@GetMapping("/list")
	public String noticeList(Model model) {
		List<Notice> noticeList = service.findAll();
		model.addAttribute("noticeList", noticeList);
		return "notice/notice-list";
	}

	// 공지사항 상세보기
	@GetMapping("/{noticeId}")
	public String noticeDetail(Model model, @PathVariable Long noticeId, HttpServletResponse response,
			@CookieValue(value = "viewedNotices", defaultValue = "") String viewed) {

		// 쿠키 검사
		String token = "[" + noticeId + "]";
		if (!viewed.contains(token)) {
			service.incrementViewCount(noticeId);
			Cookie cookie = new Cookie("viewedNotices", viewed + token);
			cookie.setMaxAge(60 * 60);
			cookie.setPath("/");
			response.addCookie(cookie);
		}

		Notice notice = service.findById(noticeId);
		model.addAttribute("notice", notice);
		return "notice/notice-detail";
	}

	// 새 글 작성 폼
	@PreAuthorize("hasRole('ADMIN')")
	@GetMapping("/new")
	public String createNoticeForm(Model model) {
		model.addAttribute("notice", new Notice()); // 빈 객체 전달
		model.addAttribute("mode", "create"); // 작성 모드
		return "notice/notice-form";
	}

	// 기존 글 수정 폼
	@PreAuthorize("hasRole('ADMIN')")
	@GetMapping("/{noticeId}/edit")
	public String editNoticeForm(Model model, @PathVariable Long noticeId) {
		Notice notice = service.findById(noticeId);
		model.addAttribute("notice", notice); // 기존 객체 전달
		model.addAttribute("mode", "edit"); // 수정 모드
		return "notice/notice-form";
	}
}
