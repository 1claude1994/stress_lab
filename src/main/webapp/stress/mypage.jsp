<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dto.MemberDto" %>
<%
    MemberDto myPage = (MemberDto) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stress Lab - MyPage</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>
<script>
    const contextPath = "<%=request.getContextPath()%>";

    // ===============================
    // [공통] 회원 관련 API 요청 함수
    // ===============================
    function requestMemberApi(action, data, successCallback) {
        const formData = new FormData();
        formData.append("action", action);
        
        // 데이터 객체의 키값들을 동적으로 FormData에 추가
        for (const key in data) {
            formData.append(key, data[key]);
        }

        fetch(contextPath + "/member", {
            method: "POST",
            body: formData
        })
        .then(res => res.text())
        .then(result => {
            if (result.includes("성공")) {
                successCallback(result);
            } else {
                alert("요청 실패 : " + result);
            }
        })
        .catch(err => {
            console.error(err);
            alert("서버 오류가 발생했습니다.");
        });
    }

    // ===============================
    // 개인정보 수정 모달 및 기능
    // ===============================
    function openProfileModal() {
        document.getElementById("profileModal").classList.remove("hidden");
    }

    function closeProfileModal() {
        document.getElementById("profileModal").classList.add("hidden");
    }

    function updateProfile() {
        const nameInput = document.getElementById("profileName");
        const emailInput = document.getElementById("profileEmail");

        const name = nameInput.value.trim();
        const email = emailInput.value.trim();

        if (name === "") {
            alert("이름을 입력해주세요.");
            nameInput.focus();
            return;
        }

        if (email === "") {
            alert("이메일을 입력해주세요.");
            emailInput.focus();
            return;
        }

        requestMemberApi("updateProfile", { name, email }, () => {
            alert("개인정보가 수정되었습니다.");
            document.getElementById("pageName").textContent = name;
            document.getElementById("pageEmail").textContent = email;
            closeProfileModal();
        });
    }

    // ===============================
    // 비밀번호 변경 모달 및 기능
    // ===============================
    function openPasswordModal() {
        document.getElementById("passwordModal").classList.remove("hidden");
    }

    function closePasswordModal() {
        document.getElementById("passwordModal").classList.add("hidden");
    }

    function updatePassword() {
        const currentPasswordInput = document.getElementById("currentPassword");
        const newPasswordInput = document.getElementById("newPassword");
        const confirmPasswordInput = document.getElementById("confirmPassword");

        const currentPassword = currentPasswordInput.value;
        const newPassword = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;

        console.log("현재 비밀번호:", `"${currentPassword}"`);
        console.log("새 비밀번호:", `"${newPassword}"`);
        console.log("확인 비밀번호:", `"${confirmPassword}"`);

        if (currentPassword === "") {
            alert("현재 비밀번호를 입력해주세요.");
            currentPasswordInput.focus();
            return;
        }

        if (newPassword === "") {
            alert("새 비밀번호를 입력해주세요.");
            newPasswordInput.focus();
            return;
        }

        if (confirmPassword === "") {
            alert("새 비밀번호 확인을 입력해주세요.");
            confirmPasswordInput.focus();
            return;
        }

        if (newPassword !== confirmPassword) {
            alert("새 비밀번호가 일치하지 않습니다.");
            confirmPasswordInput.focus();
            return;
        }

        if (currentPassword === newPassword) {
            alert("현재 비밀번호와 다른 비밀번호를 입력해주세요.");
            newPasswordInput.focus();
            return;
        }

        requestMemberApi(
            "updatePassword",
            {
                currentPassword: currentPassword,
                newPassword: newPassword,
                confirmPassword: confirmPassword
            },
            () => {
                alert("비밀번호가 변경되었습니다.");

                currentPasswordInput.value = "";
                newPasswordInput.value = "";
                confirmPasswordInput.value = "";
                
                alert("로그인 화면으로 돌아갑니다.");
                window.location.href = "stress?t_gubun=login";
                closePasswordModal();
            }
        );
    }

    // ===============================
    // 회원탈퇴 모달 및 기능
    // ===============================
    function openDeleteModal() {
        document.getElementById("deletePassword").value = "";
        document.getElementById("deleteModal").classList.remove("hidden");
    }

    function closeDeleteModal() {
        document.getElementById("deleteModal").classList.add("hidden");
    }

    function withdrawMember() {
        const passwordInput = document.getElementById("deletePassword");
        const password = passwordInput.value.trim();

        if (password === "") {
            alert("비밀번호를 입력해주세요.");
            passwordInput.focus();
            return;
        }

        if (!confirm("정말로 회원탈퇴를 진행하시겠습니까? 이 작업은 되돌릴 수 없습니다.")) {
            return;
        }

        requestMemberApi("deleteAccount", { password }, () => {
            alert("회원탈퇴가 정상적으로 처리되었습니다. 이용해 주셔서 감사합니다.");
            window.location.href = "stress?t_gubun=index";
        });
    }
</script>
<body>

    <!-- 개인정보 수정 모달 -->
    <div id="profileModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
        <div class="auth-card w-full max-w-md relative">
            <!-- 닫기 버튼 -->
            <button type="button" onclick="closeProfileModal()" class="absolute top-4 right-4 text-gray-400 hover:text-white text-xl">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <!-- 제목 -->
            <div class="auth-title">개인정보 수정</div>
            <div class="auth-subtitle mb-5">회원님의 계정 정보를 수정할 수 있습니다.</div>

            <!-- 개인정보 수정 폼 -->
            <form id="profileForm" onsubmit="event.preventDefault();">
                <!-- 아이디 -->
                <div class="profile-input-group mb-5">
                    <label>아이디</label>
                    <div class="profile-readonly">
                        <span><%= myPage.getId() %></span>
                        <i class="fa-solid fa-lock"></i>
                    </div>
                    <p class="profile-help">아이디는 변경할 수 없습니다.</p>
                </div>

                <!-- 이름 -->
                <div class="profile-input-group mb-5">
                    <label>이름</label>
                    <input type="text" name="name" id="profileName" value="<%= myPage.getName() %>" class="profile-input" placeholder="이름을 입력하세요" required>
                </div>

                <!-- 이메일 -->
                <div class="profile-input-group mb-5">
                    <label>이메일</label>
                    <input type="email" name="email" id="profileEmail" value="<%= myPage.getEmail() %>" class="profile-input" placeholder="example@email.com" required>
                </div>

                <!-- 버튼 -->
                <div class="profile-modal-buttons mb-5">
                    <button type="button" onclick="closeProfileModal()" class="px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 text-sm font-semibold transition">취소</button>
                    <button type="button" onclick="updateProfile()" class="px-4 py-2 rounded-lg bg-red-600 hover:bg-red-500 text-white font-semibold transition">
                        <i class="fa-solid fa-check"></i> 저장
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 비밀번호 변경 모달 -->
    <div id="passwordModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
        <div class="auth-card w-full max-w-md relative">
            <!-- 닫기 버튼 -->
            <button type="button" onclick="closePasswordModal()" class="absolute top-4 right-4 text-gray-400 hover:text-white text-xl">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <!-- 제목 -->
            <div class="auth-title">비밀번호 변경</div>
            <div class="auth-subtitle mb-5">회원님의 비밀번호를 안전하게 변경할 수 있습니다.</div>

            <!-- 비밀번호 변경 폼 -->
            <form id="passwordForm" onsubmit="event.preventDefault();">
                <!-- 현재 비밀번호 -->
                <div class="profile-input-group mb-5">
                    <label>현재 비밀번호</label>
                    <input type="password" name="currentPassword" id="currentPassword" class="profile-input" placeholder="현재 비밀번호를 입력하세요" required>
                </div>

                <!-- 새 비밀번호 -->
                <div class="profile-input-group mb-5">
                    <label>새 비밀번호</label>
                    <input type="password" name="newPassword" id="newPassword" class="profile-input" placeholder="새 비밀번호를 입력하세요" required>
                </div>

                <!-- 새 비밀번호 확인 -->
                <div class="profile-input-group mb-5">
                    <label>새 비밀번호 확인</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" class="profile-input" placeholder="새 비밀번호를 다시 입력하세요" required>
                </div>

                <!-- 버튼 -->
                <div class="profile-modal-buttons mb-5">
                    <button type="button" onclick="closePasswordModal()" class="px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 text-sm font-semibold transition">취소</button>
                    <button type="button" onclick="updatePassword()" class="px-4 py-2 rounded-lg bg-red-600 hover:bg-red-500 text-white font-semibold transition">
    					<i class="fa-solid fa-check"></i> 변경
					</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 회원탈퇴 모달 -->
    <div id="deleteModal" class="hidden fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
        <div class="auth-card w-full max-w-md relative">
            <!-- 닫기 버튼 -->
            <button type="button" onclick="closeDeleteModal()" class="absolute top-4 right-4 text-gray-400 hover:text-white text-xl">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <!-- 제목 -->
            <div class="auth-title text-red-500">회원탈퇴</div>
            <div class="auth-subtitle mb-5">
                탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.<br>계속하려면 비밀번호를 입력해주세요.
            </div>

            <!-- 회원탈퇴 폼 -->
            <form id="deleteForm" onsubmit="event.preventDefault();">
                <!-- 비밀번호 확인 -->
                <div class="profile-input-group mb-5">
                    <label>비밀번호 확인</label>
                    <input type="password" name="password" id="deletePassword" class="profile-input" placeholder="현재 비밀번호를 입력하세요" required>
                </div>

                <!-- 버튼 -->
                <div class="profile-modal-buttons mb-5">
                    <button type="button" onclick="closeDeleteModal()" class="px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 text-sm font-semibold transition">취소</button>
                    <button type="button" onclick="withdrawMember()" class="px-4 py-2 rounded-lg bg-red-600 hover:bg-red-500 text-white font-semibold transition">
                        <i class="fa-solid fa-user-xmark mr-1"></i> 탈퇴하기
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="flex h-screen">
        <!-- Sidebar -->
        <%@ include file="sidebar.jsp" %>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col p-8 overflow-auto space-y-6">
            <!-- Page Header -->
            <div>
                <h2 class="text-4xl font-bold">My Page</h2>
                <p class="text-gray-400 mt-2">계정 정보와 테스트 기록을 관리할 수 있습니다.</p>
            </div>

            <!-- Account Information -->
            <div class="card">
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h3 class="text-xl font-semibold">
                            <i class="fas fa-user text-red-500 mr-2"></i>Account Information
                        </h3>
                        <p class="text-sm text-gray-400 mt-1">현재 로그인한 계정 정보입니다.</p>
                    </div>
                    <!-- Account Management Buttons -->
                    <div class="flex items-center gap-3">
                        <button type="button" onclick="openProfileModal()" class="px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 text-sm font-semibold transition">
                            <i class="fa-solid fa-user-pen mr-2"></i>개인정보 수정
                        </button>
                        <button type="button" onclick="openPasswordModal()" class="px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 text-sm font-semibold transition">
                            <i class="fa-solid fa-key mr-2"></i>비밀번호 변경
                        </button>
                        <button type="button" onclick="openDeleteModal()" class="px-4 py-2 rounded-lg bg-red-600 hover:bg-red-500 text-sm font-semibold transition">
                            <i class="fa-solid fa-user-xmark mr-2"></i>회원탈퇴
                        </button>
                    </div>
                </div>

                <!-- Account Info Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="bg-gray-800 rounded-xl p-4">
                        <p class="text-sm text-gray-400 mb-1">이름</p>
                        <p id="pageName" class="text-lg font-semibold"><%= myPage.getName() %></p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <p class="text-sm text-gray-400 mb-1">아이디</p>
                        <p class="text-lg font-semibold"><%= myPage.getId() %></p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <p class="text-sm text-gray-400 mb-1">이메일</p>
                        <p id="pageEmail" class="text-lg font-semibold"><%= myPage.getEmail() %></p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <p class="text-sm text-gray-400 mb-1">가입일</p>
                        <p class="text-lg font-semibold"><%= myPage.getCreatedAt().toLocalDateTime().toLocalDate() %></p>
                    </div>
                </div>
            </div>

            <!-- Test Statistics -->
            <div>
                <h3 class="text-xl font-semibold mb-4">
                    <i class="fas fa-chart-simple text-red-500 mr-2"></i>Test Overview
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
                    <div class="card">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-gray-400 text-sm">Total Tests</p>
                                <p class="text-3xl font-bold mt-2">24</p>
                            </div>
                            <i class="fas fa-flask text-red-500 text-3xl"></i>
                        </div>
                    </div>
                    <div class="card">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-gray-400 text-sm">Port Scan</p>
                                <p class="text-3xl font-bold mt-2">12</p>
                            </div>
                            <i class="fas fa-network-wired text-blue-400 text-3xl"></i>
                        </div>
                    </div>
                    <div class="card">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-gray-400 text-sm">Stress Test</p>
                                <p class="text-3xl font-bold mt-2">8</p>
                            </div>
                            <i class="fas fa-bolt text-yellow-400 text-3xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Test History -->
            <div class="card">
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h3 class="text-xl font-semibold">
                            <i class="fas fa-clock-rotate-left text-red-500 mr-2"></i>Test History
                        </h3>
                        <p class="text-sm text-gray-400 mt-1">최근 실행한 테스트 기록입니다.</p>
                    </div>
                    <select class="custom-select" style="width: 140px;">
                        <option>All Tools</option>
                        <option>Port Scan</option>
                        <option>Stress Test</option>
                        <option>DDoS Test</option>
                    </select>
                </div>

                <!-- History Table -->
                <div class="overflow-x-auto">
                    <table class="dashboard-table w-full text-left">
                        <thead>
                            <tr class="border-b border-gray-700 text-gray-400">
                                <th class="pb-3">Tool</th>
                                <th class="pb-3">Target</th>
                                <th class="pb-3">Option</th>
                                <th class="pb-3">Status</th>
                                <th class="pb-3">Date</th>
                                <th class="pb-3">Result</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-800">
                            <tr>
                                <td class="py-3"><i class="fas fa-network-wired text-blue-400 mr-2"></i>Port Scan</td>
                                <td>192.168.0.10</td>
                                <td>-sS -T4 -F</td>
                                <td><span class="text-green-400">● Completed</span></td>
                                <td>2026-08-14 09:20</td>
                                <td><button class="text-red-400 hover:text-red-300 transition"><i class="fas fa-eye mr-1"></i>View</button></td>
                            </tr>
                            <tr>
                                <td class="py-3"><i class="fas fa-bolt text-yellow-400 mr-2"></i>Stress Test</td>
                                <td>192.168.0.20</td>
                                <td>TCP / 30s</td>
                                <td><span class="text-green-400">● Completed</span></td>
                                <td>2026-08-13 16:42</td>
                                <td><button class="text-red-400 hover:text-red-300 transition"><i class="fas fa-eye mr-1"></i>View</button></td>
                            </tr>
                            <tr>
                                <td class="py-3"><i class="fas fa-network-wired text-blue-400 mr-2"></i>Port Scan</td>
                                <td>10.0.0.5</td>
                                <td>-sV -sS -T4</td>
                                <td><span class="text-green-400">● Completed</span></td>
                                <td>2026-08-12 11:18</td>
                                <td><button class="text-red-400 hover:text-red-300 transition"><i class="fas fa-eye mr-1"></i>View</button></td>
                            </tr>
                            <tr>
                                <td class="py-3"><i class="fas fa-bolt text-yellow-400 mr-2"></i>Stress Test</td>
                                <td>192.168.1.100</td>
                                <td>UDP / 20s</td>
                                <td><span class="text-red-400">● Failed</span></td>
                                <td>2026-08-11 14:35</td>
                                <td><button class="text-red-400 hover:text-red-300 transition"><i class="fas fa-eye mr-1"></i>View</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Footer -->
            <%@ include file="footer.jsp" %>
        </div>
    </div>
</body>
</html>