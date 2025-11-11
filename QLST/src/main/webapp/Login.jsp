<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Siêu thị điện máy</title>

    <%-- CSS MỚI ĐƯỢC NHÚNG TRỰC TIẾP --%>
    <style>
        /* === CSS NHÚNG TRONG === */

        /* --- Cài đặt chung & Font --- */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6; /* Màu nền xám rất nhạt */
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;     /* Căn giữa theo chiều dọc */
            justify-content: center; /* Căn giữa theo chiều ngang */
            min-height: 100vh;       /* Full chiều cao màn hình */
        }

        /* --- Box Đăng Nhập (Style .card) --- */
        .login-container {
            background: white;
            border-radius: 8px;
            padding: 40px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            width: 350px;
            text-align: center;
            box-sizing: border-box; /* Đảm bảo padding không làm tăng width */
        }

        h2 {
            color: #005f73; /* Màu xanh đậm cho tiêu đề */
            margin-top: 0;
            margin-bottom: 25px;
        }

        /* --- Form Elements --- */
        form {
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 20px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            outline: none;
            transition: border-color 0.3s;
            box-sizing: border-box; /* Đảm bảo padding không làm tăng width */
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #008080; /* Màu Teal khi focus */
            box-shadow: 0 0 5px rgba(0, 128, 128, 0.2);
        }

        /* --- Button (Style .btn) --- */
        button {
            background-color: #008080; /* Màu xanh mòng két */
            color: white;
            border: none;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
            width: 100%; /* Full width */
            font-weight: bold;
        }

        button:hover {
            background-color: #005f73; /* Xanh đậm hơn */
        }

        /* --- Error Message (Style .alert-danger) --- */
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px 15px;
            margin-top: 20px;
            border-radius: 5px;
            font-size: 14px;
            text-align: left; /* Căn trái nội dung lỗi */
        }

    </style>
</head>
<body>

<div class="login-container">
    <h2>Đăng nhập Hệ thống DMX</h2>

    <form action="login" method="post">
        <label for="username">Tài khoản:</label>
        <input type="text" id="username" name="username" placeholder="Nhập tài khoản" required>

        <label for="password">Mật khẩu:</label>
        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>

        <button type="submit">Đăng nhập</button>
    </form>

    <%
        String error = request.getParameter("error");
        if (error != null) {
            String message = "";
            if (error.equals("invalid")) {
                message = "Sai tên đăng nhập hoặc mật khẩu.";
            } else if (error.equals("role")) {
                message = "Vai trò của bạn không được hệ thống hỗ trợ.";
            } else if (error.equals("unauthorized")) {
                message = "Chức vụ của bạn không có quyền truy cập trang này.";
            } else {
                message = "Đã xảy ra lỗi không xác định.";
            }
    %>
    <%-- Thêm icon ❌ vào trong message cho đẹp hơn --%>
    <p class="error">❌ <%= message %></p>
    <% } %>
</div>

</body>
</html>