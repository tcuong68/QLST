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
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Thêm Sản Phẩm Mới - Quản Lý Kho DMX</title>

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
            font-weight: bold;
        }

        .btn:hover {
            background-color: #005f73; /* Xanh đậm hơn */
        }

        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }

        /* --- Forms & Cards (Biểu mẫu & Thẻ) --- */
        .card {
            background: white;
            border-radius: 8px;
            padding: 30px;
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

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 25px;
        }

        .form-actions .btn {
            width: auto;
        }

        /* Style cho Input Group (Giá tiền) */
        .input-group {
            display: flex;
            position: relative;
        }
        .input-group .form-control {
            flex: 1;
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
        }
        .input-group-append {
            display: flex;
        }
        .input-group-text {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            background-color: #eee;
            border: 1px solid #ccc;
            border-left: 0;
            border-radius: 0 5px 5px 0;
            font-size: 1rem;
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
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
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
        .mr-2 { margin-right: 1rem; }

    </style>
</head>
<body>

<nav class="navbar">
    <a class="navbar-brand" href="WarehouseStaffView.jsp">
        <i class="bi bi-box-seam-fill"></i> Quản lý kho DMX
    </a>
    <a href="SearchProductView.jsp" class="btn btn-secondary" style="color:white; text-decoration: none;">
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

<main class="container">
    <div class="card">
        <h2 class="text-center" style="margin-top: 0; margin-bottom: 25px;">
            <i class="bi bi-plus-circle mr-2"></i>
            Thêm Sản Phẩm Mới
        </h2>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger" role="alert">
            <i class="bi bi-exclamation-triangle mr-2"></i>
            <%= error %>
        </div>
        <% } %>

        <form action="product" method="POST" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="add"/>

            <div class="form-group">
                <%-- Thay đổi label để dùng span.required --%>
                <label for="code">Mã sản phẩm (SKU) <span class="required">*</span></label>
                <input
                        type="text"
                        class="form-control"
                        id="code"
                        name="code"
                        required
                        placeholder="VD: TVSS001"
                />
            </div>

            <div class="form-group">
                <label for="name">Tên sản phẩm <span class="required">*</span></label>
                <input
                        type="text"
                        class="form-control"
                        id="name"
                        name="name"
                        required
                        placeholder="VD: Tivi Samsung 55 inch..."
                />
            </div>

            <div class="form-group">
                <label for="unit">Đơn vị tính <span class="required">*</span></label>
                <input
                        type="text"
                        class="form-control"
                        id="unit"
                        name="unit"
                        required
                        placeholder="VD: Cái, Chiếc, Bộ"
                />
            </div>

            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea
                        class="form-control"
                        id="description"
                        name="description"
                        rows="3"
                        placeholder="Nhập mô tả chi tiết cho sản phẩm..."
                ></textarea>
            </div>

            <div class="form-group">
                <label for="price">Giá bán <span class="required">*</span></label>
                <div class="input-group">
                    <input
                            type="number"
                            class="form-control"
                            id="price"
                            name="price"
                            min="0"
                            step="1000"
                            required
                            placeholder="Nhập giá bán"
                    />
                    <div class="input-group-append">
                        <span class="input-group-text">VNĐ</span>
                    </div>
                </div>
            </div>

            <%-- Thay thế bằng .form-actions --%>
            <div class="form-actions">
                <button
                        type="button"
                        class="btn btn-secondary mr-2"
                        onclick="window.location.href='SearchProductView.jsp'"
                >
                    <i class="bi bi-x-circle mr-2"></i>
                    Hủy
                </button>
                <button type="submit" class="btn">
                    <i class="bi bi-save mr-2"></i>
                    Lưu sản phẩm
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

<script>
    // Giữ nguyên JS validation vì không phụ thuộc jQuery/Bootstrap
    function validateForm() {
        const code = document.getElementById("code").value.trim();
        const name = document.getElementById("name").value.trim();
        const unit = document.getElementById("unit").value.trim();
        const price = document.getElementById("price").value;

        if (code.length < 3) {
            alert("Mã sản phẩm (SKU) phải có ít nhất 3 ký tự!");
            return false;
        }

        if (name.length < 3) {
            alert("Tên sản phẩm phải có ít nhất 3 ký tự!");
            return false;
        }

        if (unit.length === 0) {
            alert("Vui lòng nhập đơn vị tính!");
            return false;
        }

        if (price <= 0) {
            alert("Giá bán phải lớn hơn 0!");
            return false;
        }

        return true;
    }
</script>
</body>
</html>