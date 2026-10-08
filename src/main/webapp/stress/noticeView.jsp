<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html lang="ko">

<head>

  <!-- 기본 메타 정보 -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <title>Stress Lab - Notice View</title>

  <!-- TailwindCSS 불러오기 -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- 사용자 정의 CSS -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/styles.css">

  <!-- Font Awesome 아이콘 -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

</head>

<body>

<div class="flex h-screen">

  <!-- 사이드바 포함 -->
  <%@ include file="sidebar.jsp" %>

  <!-- 메인 컨텐츠 영역 -->
  <div class="flex-1 flex flex-col p-8 overflow-auto space-y-6">

    <!-- 상단 타이틀 -->
    <div>

      <h2 class="text-4xl font-bold">Notice</h2>

      <p class="text-gray-400 mt-2">
        Stress Lab 공지사항
      </p>

    </div>

    <!-- 공지사항 상세 보기 카드 -->
    <div class="card flex-1 flex flex-col">

      <!-- 공지 헤더 -->
      <div class="border-b border-gray-700 pb-5 mb-5">

        <!-- 공지 제목 -->
        <h3 class="text-2xl font-bold mb-4">
          ${notice.title}
        </h3>

        <!-- 작성자, 날짜, 조회수 -->
        <div class="flex gap-6 text-gray-400 text-sm">

          <span>
            <i class="fas fa-user"></i>
            ${notice.writerName}
          </span>

          <span>
            <i class="fas fa-calendar"></i>
            <fmt:formatDate value="${notice.createdAt}"
                            pattern="yyyy-MM-dd"/>
          </span>

          <span>
            <i class="fas fa-eye"></i>
            ${notice.viewCount}
          </span>

        </div>

      </div>

      <!-- 공지 내용 -->
      <div class="flex-1 text-gray-200 leading-relaxed text-base">

        ${notice.content}

      </div>

    </div>

    <!-- 하단 버튼 영역 -->
    <div class="flex justify-between items-center">

      <!-- 왼쪽: 목록 버튼 -->
      <button
        onclick="location.href='<%=request.getContextPath()%>/notice?t_gubun=notice'"
        class="h-10 w-24 rounded-xl text-white font-semibold text-sm"
        style="background: var(--dark); border:1px solid var(--border);">

        <i class="fas fa-list"></i>
        목록

      </button>

      <!-- 오른쪽: 수정/삭제 버튼 -->
      <div class="flex gap-2">

        <!-- 수정 버튼 -->
        <button
          onclick="location.href='<%=request.getContextPath()%>/notice?t_gubun=edit&notice_id=${notice.noticeId}'"
          class="h-10 w-24 rounded-xl text-white font-semibold text-sm"
          style="background: var(--red);">

          <i class="fas fa-edit"></i>
          수정

        </button>

        <!-- 삭제 버튼 -->
        <form
          action="<%=request.getContextPath()%>/notice"
          method="post"
          style="display:inline;">

          <input type="hidden"
                 name="t_gubun"
                 value="delete">

          <input type="hidden"
                 name="notice_id"
                 value="${notice.noticeId}">

          <button
            type="submit"
            class="h-10 w-24 rounded-xl text-white font-semibold text-sm"
            style="background: var(--red);">

            <i class="fas fa-trash"></i>
            삭제

          </button>

        </form>

      </div>

    </div>

    <!-- 푸터 포함 -->
    <%@ include file="footer.jsp" %>

  </div>

</div>

</body>

</html>