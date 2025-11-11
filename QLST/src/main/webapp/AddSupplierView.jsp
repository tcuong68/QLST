<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.qlst.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    String role = user.getRole();
    if (role == null || (!role.equalsIgnoreCase("staff") && !role.equalsIgnoreCase("admin"))) {
        response.sendRedirect("MainScreenView.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thêm nhà cung cấp - DMX</title>

    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
    />

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
            max-width: 700px; /* Giữ lại max-width của form gốc */
            margin: 20px auto;
            flex: 1; /* Đẩy footer xuống dưới */
        }

        h1, h2, h3, h5 {
            color: #005f73; /* Màu xanh đậm cho tiêu đề */
        }

        /* --- Header / Navbar (Thanh điều hướng) --- */
        .navbar {
            background-color: #008080; /* Màu xanh mòng két (Teal) */
            color: white;
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        .navbar-nav a {
            color: white;
            text-decoration: none;
            margin: 0 10px;
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .navbar-nav a:hover {
            background-color: #005f73;
        }

        .user-info {
            color: white;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        /* --- Footer (Chân trang) --- */
        footer {
            background-color: #333;
            color: #eee;
            text-align: center;
            padding: 1.5rem;
            margin-top: auto; /* Dính xuống đáy */
        }

        /* --- Buttons (Nút bấm) --- */
        .btn {
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
            line-height: 1.5;
            font-weight: bold; /* Thêm cho nút form */
        }

        .btn:hover {
            background-color: #005f73; /* Xanh đậm hơn */
        }

        /* Các biến thể màu nút */
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }

        /* --- Forms & Cards (Biểu mẫu & Thẻ) --- */
        .card {
            background: white;
            border-radius: 8px; /* Giảm bo góc */
            padding: 30px; /* Đồng nhất padding */
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }

        /* Class chung cho input, textarea */
        .form-control {
            width: 100%;
            padding: 12px 15px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            outline: none;
            transition: border-color 0.3s;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        .form-control:focus {
            border-color: #008080;
            box-shadow: 0 0 5px rgba(0, 128, 128, 0.2);
        }

        .required {
            color: #dc3545;
            margin-left: 2px;
        }

        /* Căn chỉnh nhóm nút */
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 25px;
        }

        .form-actions .btn {
            width: auto; /* Nút không full-width */
        }

        /* --- Style từ trang Dashboard (Navbar) --- */
        .user-badge {
            background-color: #005f73;
            padding: 0.4rem 1rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            color: white;
        }
        .btn-logout {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 0.4rem 1rem;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-logout:hover {
            background: #dc3545;
            border-color: #dc3545;
            color: white;
        }

        /* --- Lớp tiện ích (Utility Classes) --- */
        .text-center { text-align: center; }
        .text-muted { color: #6c757d; }

    </style>
</head>
<body>
<nav class="navbar">
    <a class="navbar-brand" href="WarehouseStaffView.jsp">
        <i class="bi bi-box-seam-fill"></i> Quản lý kho DMX
    </a>
    <%-- Đổi btn-home thành btn-secondary --%>
    <a href="supplier?action=search" class="btn btn-secondary" style="color:white; text-decoration: none;">
        <i class="bi bi-arrow-left-circle-fill"></i> Quay lại
    </a>
    <div class="user-info">
        <i class="bi bi-person-circle"></i>
        Xin chào,
        <strong>
            <%= user.getName() != null ? user.getName() : user.getUsername() %>
        </strong>
    </div>
</nav>

<%-- Bỏ page-header --%>

<main class="container">
    <%-- Thêm tiêu đề h2 --%>
    <h2 class="text-center" style="margin: 20px 0;">
        <i class="bi bi-plus-circle"></i> Thêm nhà cung cấp mới
    </h2>

    <%-- Thay .form-card bằng .card --%>
    <div class="card">
        <h5 style="margin-bottom: 25px;">
            <i class="bi bi-building" style="color: #008080"></i>
            Thông tin nhà cung cấp
        </h5>

        <form method="post" action="supplier?action=add">
            <div class="form-group">
                <label for="name">Tên nhà cung cấp <span class="required">*</span></label>
                <input
                        type="text"
                        id="name"
                        name="name"
                        class="form-control"
                        placeholder="VD: Công ty TNHH Phụ Tùng ABC"
                        required
                />
            </div>

            <div class="form-group">
                <label for="phone">Số điện thoại <span class="required">*</span></label>
                <input
                        type="tel"
                        id="phone"
                        name="phone"
                        class="form-control"
                        placeholder="VD: 0901234567"
                        pattern="[0-9]{10,11}"
                        title="Số điện thoại phải có 10-11 chữ số"
                        required
                />
            </div>

            <div class="form-group">
                <label for="email">Email <span class="required">*</span></label>
                <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-control"
                        placeholder="VD: contact@abc.com"
                        required
                />
            </div>

            <div class="form-group">
                <label for="address">Địa chỉ</label>
                <textarea
                        id="address"
                        name="address"
                        rows="3"
                        class="form-control"
                        placeholder="VD: 123 Đường ABC, Quận XYZ, Thành phố..."
                ></textarea>
                <small class="text-muted">Địa chỉ không bắt buộc</small>
            </div>

            <%-- Thay .row bằng .form-actions --%>
            <div class.form-actions">
            <a href="supplier?action=search" class="btn btn-secondary">
                <i class="bi bi-x-circle"></i> Hủy
            </a>
            <button type="submit" class="btn">
                <i class="bi bi-check-circle"></i> Lưu nhà cung cấp
            </button>
    </div>
    </form>
    </div>
</main>

<%-- Thêm footer đồng nhất --%>
<footer>
    <p>© 2025 - Hệ thống quản lý Siêu thị Điện máy DMX</p>
</footer>

<%-- Xóa script của jQuery và Bootstrap --%>
</body>
</html>