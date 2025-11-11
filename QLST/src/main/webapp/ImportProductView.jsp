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
    <title>Nhập Chi Tiết Sản Phẩm - DMX</title>

    <%-- Xóa link Bootstrap --%>
    <%-- Giữ lại link icon --%>
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
            max-width: 1200px;
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
        }

        .btn:hover {
            background-color: #005f73; /* Xanh đậm hơn */
        }

        .btn:disabled {
            background-color: #aaa;
            cursor: not-allowed;
            opacity: 0.7;
        }

        /* Các biến thể màu nút */
        .btn-success {
            background-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
        }

        .btn-danger {
            background-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
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
            padding: 30px; /* Tăng padding */
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="number"] { /* Thêm type="number" */
            width: 100%;
            padding: 12px 15px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            outline: none;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="tel"]:focus,
        input[type="number"]:focus {
            border-color: #008080;
            box-shadow: 0 0 5px rgba(0, 128, 128, 0.2);
        }

        /* --- Tables (Bảng) --- */
        .table-container {
            overflow-x: auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid #ddd;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }

        table thead {
            background-color: #005f73; /* Xanh đậm */
            color: white;
        }

        table th, table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
        }

        table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        table tbody tr:hover {
            background-color: #eef;
        }

        /* Style riêng cho input trong table */
        table input[type="number"] {
            width: 90%; /* Không full 100% để đẹp hơn */
            padding: 8px 10px;
            font-size: 0.95rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.3s;
        }
        table input[type="number"]:focus {
            border-color: #008080;
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
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .text-muted { color: #6c757d; }
        .mr-1 { margin-right: 0.5rem; }
        .mr-2 { margin-right: 1rem; }

    </style>
</head>

<body>

<nav class="navbar">
    <a class="navbar-brand" href="WarehouseStaffView.jsp">
        <i class="bi bi-box-seam-fill"></i> Quản Lý Kho DMX
    </a>
    <div class="user-info">
      <span class="user-badge">
        <i class="bi bi-person-badge"></i> <%= user.getRole().toUpperCase() %>
      </span>
        <span>
        <i class="bi bi-person-circle"></i>
        <strong>
            <%= user.getName() != null ? user.getName() : user.getUsername() %>
        </strong>
      </span>
        <a href="Login.jsp" class="btn-logout">
            <i class="bi bi-box-arrow-right"></i> Đăng xuất
        </a>
    </div>
</nav>

<div class="container">
    <%-- Bỏ .card và .header-gradient gốc --%>
    <h2 class="text-center" style="margin-bottom: 20px;">
        <i class="bi bi-bag-plus"></i> Nhập Chi Tiết Sản Phẩm
    </h2>

    <div class="card">
        <%-- Bỏ .card-body --%>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger" role="alert">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <%= request.getAttribute("error") %>
        </div>
        <% } %>
        <p class="text-muted">
            Điền giá nhập và số lượng cho từng <strong>sản phẩm</strong> đã chọn. Dữ liệu sẽ được
            lưu tạm để hoàn tất sau.
        </p>

        <form method="post" action="product" id="importForm">
            <input type="hidden" name="action" value="prepareImport" />
            <input type="hidden" name="returnWithSearch" value="true" />

            <%-- Thêm .table-container --%>
            <div class="table-container">
                <%-- Bỏ class table-bordered table-hover --%>
                <table>
                    <thead>
                    <tr>
                        <th style="width: 5%">#</th>
                        <th style="width: 55%">Tên sản phẩm</th>
                        <th style="width: 25%">Giá nhập (VNĐ)</th>
                        <th style="width: 15%">Số lượng</th>
                    </tr>
                    </thead>
                    <tbody id="importBody"></tbody>
                </table>
            </div>

            <div class="text-right" style="margin-top: 20px;">
                <%-- Cập nhật class cho button --%>
                <a href="SearchProductView.jsp" class="btn btn-secondary mr-2">
                    <i class="bi bi-arrow-left-circle mr-1"></i>Quay lại
                </a>
                <button type="submit" class="btn">
                    <i class="bi bi-download mr-1"></i>Thêm vào danh sách nhập
                </button>
            </div>
        </form>
    </div>
</div>

<%-- Thêm footer đồng nhất --%>
<footer>
    <p>© 2025 - Hệ thống quản lý Siêu thị Điện máy DMX</p>
</footer>

<%-- Xóa script của jQuery và Bootstrap --%>

<script>
    let selectedItems = [];
    function renderRows(items) {
        selectedItems = items ? items.map((it) => ({ ...it })) : [];

        const tbody = document.getElementById("importBody");
        tbody.innerHTML = "";

        if (!items || !items.length) {
            return;
        }

        items.forEach((it, idx) => {
            const safeId =
                it && typeof it.id !== "undefined" && it.id !== null
                    ? String(it.id)
                    : "";

            const rawName = it && it.name ? String(it.name) : "";

            // Sửa lỗi: Bỏ ${priceDefault} và ${qtyDefault}
            const tr = document.createElement("tr");
            tr.innerHTML = `
              <td class="text-center">${idx + 1}</td>
              <td>
                <strong class="product-name"></strong> </td>
              <td>
                <input type="number" class="price-input" name="importPrice"
                       min="0" step="1000" value="0">
              </td>
              <td>
                <input type="number" class="qty-input" name="importQty"
                       min="1" step="1" value="1">
              </td>
            `;
            // Gán textContent để tránh lỗi XSS
            tr.querySelector(".product-name").textContent = rawName;
            tbody.appendChild(tr);
        });
    }

    document
        .getElementById("importForm")
        .addEventListener("submit", function (e) {
            e.preventDefault();

            this.querySelectorAll(".import-hidden-field").forEach((node) =>
                node.remove()
            );

            if (selectedItems && selectedItems.length) {
                // Lấy giá trị từ các input
                const priceInputs = this.querySelectorAll("input[name='importPrice']");
                const qtyInputs = this.querySelectorAll("input[name='importQty']");

                selectedItems.forEach((item, index) => {
                    const hasValidId =
                        item &&
                        item.id !== null &&
                        item.id !== undefined &&
                        String(item.id).trim() !== "";
                    if (hasValidId) {
                        // Thêm hidden field cho ID
                        const hiddenId = document.createElement("input");
                        hiddenId.type = "hidden";
                        hiddenId.name = "itemId";
                        hiddenId.value = item.id;
                        hiddenId.className = "import-hidden-field";
                        this.appendChild(hiddenId);

                        // Thêm hidden field cho Tên
                        const hiddenName = document.createElement("input");
                        hiddenName.type = "hidden";
                        hiddenName.name = "itemName";
                        hiddenName.value = item.name != null ? item.name : "";
                        hiddenName.className = "import-hidden-field";
                        this.appendChild(hiddenName);

                        // Thêm hidden field cho Giá và Số lượng
                        if(priceInputs[index] && qtyInputs[index]) {
                            const hiddenPrice = document.createElement("input");
                            hiddenPrice.type = "hidden";
                            hiddenPrice.name = "importPrice";
                            hiddenPrice.value = priceInputs[index].value;
                            hiddenPrice.className = "import-hidden-field";
                            this.appendChild(hiddenPrice);

                            const hiddenQty = document.createElement("input");
                            hiddenQty.type = "hidden";
                            hiddenQty.name = "importQty";
                            hiddenQty.value = qtyInputs[index].value;
                            hiddenQty.className = "import-hidden-field";
                            this.appendChild(hiddenQty);
                        }
                    }
                });
            }

            // Xóa input 'importPrice' và 'importQty' ban đầu khỏi form
            // vì ta đã thêm chúng vào hidden fields
            this.querySelectorAll("input[name='importPrice']:not(.import-hidden-field)").forEach(el => el.name = "");
            this.querySelectorAll("input[name='importQty']:not(.import-hidden-field)").forEach(el => el.name = "");

            this.submit();

            sessionStorage.removeItem("selectedProducts");
        });

    const selected = JSON.parse(
        sessionStorage.getItem("selectedProducts") || "[]"
    );
    if (!selected.length) {
        window.location.href = "SearchProductView.jsp";
    } else {
        renderRows(selected);
    }
</script>
</body>
</html>