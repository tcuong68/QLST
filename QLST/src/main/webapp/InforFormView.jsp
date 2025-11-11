<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Membership - Siêu Thị Điện Máy DMX</title>

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
            flex-direction: column;
            min-height: 100vh;
        }

        .container {
            width: 90%;
            max-width: 500px; /* Giữ lại width của form gốc */
            margin: 20px auto;
            flex: 1;
        }

        h1, h2, h3 {
            color: #005f73; /* Màu xanh đậm cho tiêu đề */
        }

        /* --- Header / Navbar (Thanh điều hướng) --- */
        .navbar {
            background-color: #008080; /* Màu xanh mòng két (Teal) */
            color: white;
            padding: 1rem;
            display: flex;
            justify-content: center; /* Căn giữa cho trang này */
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        /* --- Footer (Chân trang) --- */
        footer {
            background-color: #333;
            color: #eee;
            text-align: center;
            padding: 1.5rem;
            margin-top: auto; /* Dính xuống đáy */
        }

        /* --- Box Đăng Ký (Style .card) --- */
        .form-container { /* Đổi tên từ login-container */
            background: white;
            border-radius: 8px;
            padding: 40px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            width: 100%; /* Sẽ bị giới hạn bởi .container */
            text-align: center;
            box-sizing: border-box;
            margin-top: 20px;
        }

        .form-container h2 {
            margin-top: 0;
            margin-bottom: 25px;
            text-align: center;
        }

        /* --- Form Elements --- */
        form {
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 8px;
            margin-top: 15px; /* Giữ lại khoảng cách */
            font-weight: bold;
            color: #333;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"] {
            width: 100%;
            padding: 12px 15px;
            margin-top: 5px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            outline: none;
            transition: border-color 0.3s;
            box-sizing: border-box; /* Đảm bảo padding không làm tăng width */
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="tel"]:focus {
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
            margin-top: 25px; /* Tăng khoảng cách */
        }

        button:hover {
            background-color: #005f73; /* Xanh đậm hơn */
        }

        /* --- Alerts (Thông báo) --- */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 10px;
            text-align: left;
        }

        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        .alert-warning {
            color: #856404;
            background-color: #fff3cd;
            border-color: #ffeeba;
        }

        /* --- Back link --- */
        a.back {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #008080;
            text-decoration: none;
            font-weight: bold;
        }
        a.back:hover {
            text-decoration: underline;
            color: #005f73;
        }

    </style>
</head>
<body>
<%-- Thay <header> bằng <nav class="navbar"> --%>
<nav class="navbar">
    <a href="#" class="navbar-brand">Đăng Ký Thẻ Thành Viên</a>
</nav>

<div class="container">
    <%-- Thêm class .form-container --%>
    <div class="form-container">
        <h2>Thông tin thành viên</h2>

        <%
            String status = request.getParameter("status");
            if ("success".equals(status)) {
        %>
        <%-- Thay class .message.success bằng .alert.alert-success --%>
        <div class="alert alert-success">🎉 Đăng ký thẻ thành viên thành công!</div>
        <%
        } else if ("error".equals(status)) {
        %>
        <div class="alert alert-danger">❌ Có lỗi xảy ra. Vui lòng thử lại sau.</div>
        <%
        } else if ("exists".equals(status)) {
        %>
        <div class="alert alert-warning">⚠️ Bạn đã có thẻ thành viên. Không thể đăng ký thêm.</div>
        <%
        } else if ("invalid_action".equals(status)) {
        %>
        <div class="alert alert-danger">❌ Lỗi: Hành động không hợp lệ.</div>
        <%
            }
        %>

        <form action="membership-card" method="post">
            <input type="hidden" name="action" value="create">
            <label for="name">Họ và tên:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="phone">Số điện thoại:</label>
            <input type="tel" id="phone" name="phone" required>

            <button type="submit">Đăng ký</button>
        </form>

        <a href="MainScreenView.jsp" class="back">← Quay lại trang chủ</a>
    </div>
</div>

<%-- Thêm footer đồng nhất --%>
<footer>
    <p>© 2025 - Hệ thống quản lý Siêu thị Điện máy DMX</p>
</footer>

</body>
</html>