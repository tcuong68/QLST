<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page
        import="java.util.*,
                org.example.qlst.model.User,
                org.example.qlst.model.Product" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    String role = user.getRole();
    if (role == null || (!role.equalsIgnoreCase("staff") &&
            !role.equalsIgnoreCase("admin"))) {
        response.sendRedirect("MainScreenView.jsp");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
    boolean hasSearched = request.getParameter("action") != null ||
            request.getAttribute("products") != null;
    if (products == null) {
        products = new ArrayList<>();
    }
    String supplierName = request.getParameter("supplierName");
    if (supplierName == null) {
        supplierName = (String) session.getAttribute("selectedSupplierName");
    }
    Integer supplierId = null;
    try {
        String supplierIdParam = request.getParameter("supplierId");
        if (supplierIdParam != null && !supplierIdParam.trim().isEmpty()) {
            supplierId = Integer.parseInt(supplierIdParam.trim());
            session.setAttribute("selectedSupplierId", supplierId);
        } else {
            supplierId = (Integer) session.getAttribute("selectedSupplierId");
        }
    } catch (Exception ignore) {
        supplierId = (Integer) session.getAttribute("selectedSupplierId");
    }
    if (supplierName != null && !supplierName.trim().isEmpty()) {
        session.setAttribute("selectedSupplierName", supplierName);
    }

    java.util.List<org.example.qlst.model.ImportReceiptDetail> pendingItems =
            (java.util.List<org.example.qlst.model.ImportReceiptDetail>) session.getAttribute("pendingImportItems");
    java.util.Map<Integer, String> pendingNames =
            (java.util.Map<Integer, String>) session.getAttribute("pendingImportNames");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Tìm Sản Phẩm - Quản Lý Kho DMX</title>

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
            min-height: 100vh; /* Đảm bảo footer luôn ở cuối trang */
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            flex: 1; /* Đẩy footer xuống dưới */
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
            background-color: #005f73; /* Màu xanh đậm hơn khi hover */
        }

        .user-info {
            color: white;
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
            line-height: 1.5; /* Căn chỉnh text */
        }

        .btn:hover {
            background-color: #005f73; /* Xanh đậm hơn */
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
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .input-group {
            display: flex;
            width: 100%;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-radius: 5px;
            position: relative; /* Thêm cho icon */
        }

        .input-group input[type="text"] {
            flex: 1;
            padding: 12px 15px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px 0 0 5px;
            outline: none;
            transition: border-color 0.3s;
        }

        .input-group input[type="text"]:focus {
            border-color: #008080;
        }

        .input-group .btn {
            border-radius: 0 5px 5px 0;
            /* Nút sẽ tự động nhận style từ .btn */
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
            background-color: #eef; /* Màu xanh nhạt khi hover */
            cursor: pointer;
        }

        table tbody tr.selected {
            background-color: #d6f5f5; /* Màu xanh mòng két rất nhạt */
            border-left: 4px solid #008080;
            font-weight: bold;
        }

        /* --- Input Checkbox/Radio --- */
        input[type="checkbox"], input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #008080; /* Màu của dấu tick/chọn */
            vertical-align: middle;
        }

        /* --- Alerts (Thông báo) --- */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 10px; /* Khoảng cách giữa icon và text */
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

        /* --- Nút bấm nổi (Floating Button) --- */
        .btn-floating {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            /* Kế thừa style từ .btn */
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 700;
            border-radius: 50px;
            box-shadow: 0 8px 25px rgba(0, 128, 128, 0.3);
            z-index: 1000;
        }

        .btn-floating:disabled {
            background-color: #aaa;
            cursor: not-allowed;
            opacity: 0.7;
        }
    </style>

    <%-- Giữ lại link icon --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"/>
</head>
<body>
<nav class="navbar">
    <a class="navbar-brand" href="WarehouseStaffView.jsp">
        <i class="bi bi-box-seam-fill"></i> Quản Lý Kho DMX
    </a>
    <div class="navbar-nav">
        <a href="SearchSupplierView.jsp" class="btn btn-secondary" style="color:white; text-decoration: none;">
            <i class="bi bi-arrow-left-circle-fill"></i> Quay lại chọn NCC
        </a>
    </div>
    <div class="user-info">
        <i class="bi bi-person-circle"></i>
        Xin chào,
        <strong>
            <%= user.getName() != null ? user.getName() : user.getUsername() %>
        </strong>
    </div>
</nav>

<div class="container">
    <h3 style="text-align: center; margin-bottom: 20px;">
        <i class="bi bi-box-seam"></i> Tìm kiếm Sản Phẩm
    </h3>

    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success" role="alert">
        <i class="bi bi-check-circle-fill"></i>
        <span><%= request.getAttribute("success") %></span>
    </div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger" role="alert">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <span><%= request.getAttribute("error") %></span>
    </div>
    <% } %>

    <div style="display: flex; justify-content: flex-end; margin-bottom: 20px;">
        <a href="AddProductView.jsp" class="btn btn-success">
            <i class="bi bi-plus-circle"></i>
            Thêm sản phẩm mới
        </a>
    </div>

    <% if (supplierName != null) { %>
    <div class="card">
        <i class="bi bi-truck"></i> Nhà cung cấp: <strong><%= supplierName %></strong>
    </div>
    <% } %>

    <div class="card">
        <form method="get" action="product" id="searchForm">
            <input type="hidden" name="action" value="search"/>
            <input type="hidden" name="supplierName" value="<%= supplierName!= null ? supplierName : "" %>"/>
            <input type="hidden" name="supplierId" value="<%= supplierId != null ? supplierId : "" %>"/>
            <div class="input-group">
                 <span style="position: absolute; left: 15px; top: 13px; z-index: 10; color: #6c757d;">
                     <i class="bi bi-search"></i>
                 </span>
                <input type="text" name="q" id="searchInput"
                       placeholder="Tìm kiếm sản phẩm theo tên..."
                       value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>"
                       style="padding-left: 40px;"/>
                <button type="submit" class="btn">
                    <i class="bi bi-search"></i> Tìm kiếm
                </button>
            </div>
        </form>
    </div>

    <div id="productList" style="margin-top: 20px;">
        <% if (!hasSearched) { %>
        <div class="card" style="text-align: center; color: #6c757d;">
            <i class="bi bi-search" style="font-size: 3rem;"></i>
            <h5 class="mt-3">Nhập tên sản phẩm và nhấn "Tìm kiếm"</h5>
        </div>
        <% } else if (products.isEmpty()) { %>
        <div class="card" style="text-align: center; color: #6c757d;">
            <i class="bi bi-inbox" style="font-size: 3rem"></i>
            <h5 class="mt-3">Không tìm thấy sản phẩm</h5>
            <p>Không có kết quả nào phù hợp với từ khóa "<strong><%= request.getParameter("q") != null ? request.getParameter("q") : "" %></strong>"</p>
        </div>
        <% } else { %>
        <div style="margin-bottom: 15px;">
            <h6 style="color: #555;">
                <i class="bi bi-check-circle-fill" style="color: #28a745;"></i>
                Tìm thấy <strong><%= products.size() %></strong> sản phẩm
                <% if (request.getParameter("q") != null && !request.getParameter("q").isEmpty()) { %>
                cho từ khóa "<strong><%= request.getParameter("q") %></strong>" <% } %>
            </h6>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th style="width: 5%">STT</th>
                    <th style="width: 40%">Tên sản phẩm</th>
                    <th style="width: 20%">Giá bán (VNĐ)</th>
                    <th style="width: 15%">Tồn kho</th>
                    <th style="width: 15%; text-align: center;">Chọn</th>
                </tr>
                </thead>
                <tbody>
                <% int stt = 1;
                    for (Product product : products) { %>
                <tr
                        onclick="selectProduct(this)"
                        data-id="<%= product.getId() %>"
                        data-name="<%= product.getName() %>"
                        data-price="<%= product.getPrice() %>"
                        data-quantity="<%= product.getQuantity() %>"
                >
                    <td style="text-align: center;"><%= stt++ %></td>
                    <td><strong><%= product.getName() %></strong></td>
                    <td><%= String.format("%,d", (int) product.getPrice()) %></td>
                    <td style="text-align: center;"><%= product.getQuantity() %></td>
                    <td style="text-align: center;">
                        <input type="checkbox" class="product-checkbox"/>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <% if (pendingItems != null && !pendingItems.isEmpty()) { %>
    <div style="margin-top: 40px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
            <h5 style="margin: 0;"><i class="bi bi-bag-check-fill" style="color: #28a745;"></i> Danh sách nhập
                (<%= pendingItems.size() %>)</h5>
            <a href="product?action=clearPending" class="btn btn-danger" style="padding: 8px 12px; font-size: 14px;">
                <i class="bi bi-trash"></i> Xóa danh sách
            </a>
        </div>
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th style="width:8%">STT</th>
                    <th style="width:45%">Tên sản phẩm</th>
                    <th style="width:20%">Giá nhập (VNĐ)</th>
                    <th style="width:15%">Số lượng</th>
                    <th style="width:15%; text-align: right;">Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int idx = 1;
                    long total = 0;
                    for (org.example.qlst.model.ImportReceiptDetail it : pendingItems) {
                        long sub = Math.round(it.getPrice() * it.getQuantity());
                        total += sub;
                %>
                <tr>
                    <td style="text-align: center;"><%= idx++ %></td>
                    <td>
                        <strong><%= pendingNames != null ? pendingNames.getOrDefault(it.getProductId(), "Không xác định") : "Không xác định" %></strong>
                    </td>
                    <td><%= String.format("%,d", (long) it.getPrice()) %></td>
                    <td style="text-align: center;"><%= it.getQuantity() %></td>
                    <td style="text-align: right;"><%= String.format("%,d", sub) %></td>
                </tr>
                <% } %>
                </tbody>
                <tfoot>
                <tr style="background: #f4f7f6; font-weight: bold;">
                    <td colspan="4" style="text-align: right;">Tổng</td>
                    <td style="text-align: right;"><%= String.format("%,d", total) %></td>
                </tr>
                </tfoot>
            </table>
        </div>
        <div style="display: flex; justify-content: flex-end; margin-top: 20px;">
            <form method="post" action="product" style="margin: 0;">
                <input type="hidden" name="action" value="finalizeImport"/>
                <button type="submit" class="btn">
                    <i class="bi bi-check2-circle"></i> Hoàn thành đơn nhập
                </button>
            </form>
        </div>
    </div>
    <% } %>
</div>

<button
        class="btn-floating"
        id="btnContinue"
        onclick="continueToImport()"
        disabled
>
    Tiếp tục <i class="bi bi-arrow-right-circle-fill"></i>
</button>

<footer>
    <p>© 2025 - Hệ thống quản lý Siêu thị Điện máy DMX</p>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    let selectedProducts = [];

    function selectProduct(row) {
        const checkbox = $(row).find(".product-checkbox");
        checkbox.prop("checked", !checkbox.prop("checked"));
        toggleSelection(row, checkbox.prop("checked"));
    }

    $(function () {
        $(".product-checkbox").on("click", function (e) {
            e.stopPropagation();
            const row = $(this).closest("tr");
            toggleSelection(row, $(this).prop("checked"));
        });

        // Cập nhật lại giao diện cho các hàng đã chọn khi quay lại trang
        try {
            const storedProducts = JSON.parse(sessionStorage.getItem("selectedProducts") || "[]");
            storedProducts.forEach(product => {
                const row = $(`tr[data-id="${product.id}"]`);
                if(row.length) {
                    row.addClass("selected");
                    row.find(".product-checkbox").prop("checked", true);
                }
            });
            selectedProducts = storedProducts;
            $("#btnContinue").prop("disabled", selectedProducts.length === 0);
        } catch(e) {
            sessionStorage.removeItem("selectedProducts");
        }
    });

    function toggleSelection(row, isChecked) {
        const productData = {
            id: $(row).data("id"),
            name: $(row).data("name"),
            price: $(row).data("price"),
            quantity: $(row).data("quantity"),
        };

        if (isChecked) {
            $(row).addClass("selected");
            if (!selectedProducts.find((p) => p.id === productData.id)) {
                selectedProducts.push(productData);
            }
        } else {
            $(row).removeClass("selected");
            selectedProducts = selectedProducts.filter(
                (p) => p.id !== productData.id
            );
        }
        $("#btnContinue").prop("disabled", selectedProducts.length === 0);
    }

    function continueToImport() {
        if (selectedProducts.length === 0) {
            alert("Vui lòng chọn ít nhất một sản phẩm!");
            return;
        }
        sessionStorage.setItem(
            "selectedProducts",
            JSON.stringify(selectedProducts)
        );
        window.location.href = "ImportProductView.jsp";
    }
</script>
</body>
</html>