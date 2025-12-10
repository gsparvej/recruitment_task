# 🚀 Admin Module: HR Management System

This README provides an overview of the **Admin Module** for the Human Resources (HR) Management System, based on the provided UI screenshots. This module serves as the central control panel for managing the organization's structure, employee data, attendance records, and leave requests.

---

## 🌟 Key Features

The Admin Module is designed to give administrators comprehensive control over the HR system. The primary functionalities include:

* **Dashboard & Navigation:** Provides quick access to all features and a system overview.
* **User Profile Management:** Ability to view and update the administrator's profile details.
* **Organizational Structure:** Management of organizational departments and employee designations.
* **Daily Attendance Logging:** Monitoring and reviewing daily employee check-in and check-out records.
* **Active Employee Directory:** Viewing the current list of active employees and their details.
* **Leave Management:** Reviewing, approving, or rejecting employee leave applications.

---

## 🖼️ Module Screenshots Overview

The paths have been updated to reflect the structure: `screenshots/task1/filename.PNG`.

| Screenshot | File Name | Image Link | Description |
| :--- | :--- | :--- | :--- |
| **Dashboard** | `homePage.PNG` | ![Admin Dashboard](screenshots/task1/homePage.PNG) | The main view with a sidebar for easy navigation to all sub-modules. |
| **Admin Profile** | `admin profile.PNG` | ![Admin Profile](screenshots/admin/admin%20profile.PNG) | The screen for viewing or updating the administrator's personal and account information. |
| **Departments** | `all departments.PNG` | ![All Departments](screenshots/admin/all%20departments.PNG) | Lists all organizational departments (e.g., Production, Marketing). |
| **Daily Attendance** | `attendance.PNG` | ![Daily Attendance](screenshots/admin/attendance.PNG) | Shows records of daily employee attendance (e.g., check-in/check-out). |
| **Designations** | `designations.PNG` | ![Designations](screenshots/admin/designations.PNG) | Lists all job roles or titles within the organization. |
| **Employee List** | `employee list.PNG` | ![Employee List](screenshots/admin/employee%20list.PNG) | A directory of all active employees, including basic details. |
| **Leave Report** | `leave.PNG` | ![Leave Report](screenshots/admin/leave.PNG) | Displays reports or a queue of pending/approved employee leave applications. |

---

## ⚙️ Technical Structure

The Admin Module typically integrates with the following backend entities and APIs:

| Data Entity | Primary Management Screens | Key Operations (CRUD) |
| :--- | :--- | :--- |
| **Department** | `all departments.PNG` | Create, Read, Update, Delete organizational units. |
| **Designation** | `designations.PNG` | CRUD job titles/roles. |
| **Employee** | `employee list.PNG` | Read employee profiles, basic management (e.g., activation/deactivation). |
| **Attendance** | `attendance.PNG` | Read/Review daily check-in/out records. |
| **Leave Request** | `leave.PNG` | Read, Approve, Reject leave requests. |

---

## 🔒 Access and Security

This module is restricted to users with **Admin** privileges. Access control ensures only authorized personnel can view and modify organizational and employee data.

---


 <!-- merchandiser section -->

 # 👗 Merchandiser Module: Garments Management System (RMG)

This README provides a complete overview of the **Merchandiser Module** based on the provided UI screenshots. This module is designed to manage the merchandising workflow, including buyers, orders, BOM (Bill of Materials), raw material calculations, and UOM (Unit of Measurement) management.

---

## 🌟 Key Features

The Merchandiser Module offers end‑to‑end control over merchandising operations:

* **Buyer Management:** Add, view, and manage buyer profiles.
* **Order Management:** Create and track orders, view detailed breakdowns, and search orders.
* **BOM (Bill of Materials):** Generate, edit, and view BOM by style code or as a list.
* **Raw Material Calculations:** Auto‑calculate required materials for production based on style and order.
* **UOM Management:** Manage units of measurement used across materials and orders.
* **Merchandiser Dashboard & Profile:** Overview of tasks with profile viewing options.

---

## 🖼️ Module Screenshots Overview

Below is the screenshot documentation with paths: `screenshots/merchandiser/filename.PNG`.

| Screenshot                             | File Name                                  | Preview                                                                                      | Description                                        |
| :------------------------------------- | :----------------------------------------- | :------------------------------------------------------------------------------------------- | :------------------------------------------------- |
| **Add Buyer (Form 1)**                 | `add buyer 1.PNG`                          | ![add buyer 1](screenshots/merchandiser/add%20buyer%201.PNG)                                 | Basic buyer information input form.                |
| **Add Buyer (Form 2)**                 | `add buyer 2.PNG`                          | ![add buyer 2](screenshots/merchandiser/add%20buyer%202.PNG)                                 | Additional buyer details submission screen.        |
| **BOM Details by Style Code**          | `BOM details by StyleCode.PNG`             | ![BOM details style](screenshots/merchandiser/BOM%20details%20by%20StyleCode.PNG)            | BOM breakdown for a specific style code.           |
| **BOM List**                           | `BOM list.PNG`                             | ![bom list](screenshots/merchandiser/BOM%20list.PNG)                                         | List of all generated BOMs.                        |
| **Buyer List**                         | `buyer list.PNG`                           | ![buyer list](screenshots/merchandiser/buyer%20list.PNG)                                     | Displays all registered buyers.                    |
| **Merchandiser Dashboard**             | `merchandiser dashboard.PNG`               | ![dashboard](screenshots/merchandiser/merchandiser%20dashboard.PNG)                          | Quick access panel for all merchandising features. |
| **Merchandiser Profile**               | `merchandiser profile.PNG`                 | ![profile](screenshots/merchandiser/merchandiser%20profile.PNG)                              | Shows merchandiser personal information.           |
| **Order Details (1)**                  | `order details 1.PNG`                      | ![order 1](screenshots/merchandiser/order%20details%201.PNG)                                 | Overview of an order with key attributes.          |
| **Order Details (2)**                  | `order details 2.PNG`                      | ![order 2](screenshots/merchandiser/order%20details%202.PNG)                                 | Extended view of order specifications.             |
| **Order List (Search View)**           | `order list by searching.PNG`              | ![order search](screenshots/merchandiser/order%20list%20by%20searching.PNG)                  | Orders filtered by search criteria.                |
| **Order List (Full List)**             | `order list.PNG`                           | ![order list](screenshots/merchandiser/order%20list.PNG)                                     | Complete list of all orders.                       |
| **Raw Materials Calculation (Search)** | `raw materials calculations by search.PNG` | ![raw mat search](screenshots/merchandiser/raw%20materials%20calculations%20by%20search.PNG) | Search and calculate required raw materials.       |
| **Raw Materials Calculation (List)**   | `raw materials calculations list.PNG`      | ![raw mat list](screenshots/merchandiser/raw%20materials%20calculations%20list.PNG)          | List of all previously calculated raw materials.   |
| **UOM List**                           | `UOM.PNG`                                  | ![uom](screenshots/merchandiser/UOM.PNG)                                                     | Displays all unit of measurement items.            |

---

## ⚙️ Technical Structure

Below is the structural mapping of module entities and primary operations:

| Entity            | Related Screens                     | Main Operations                    |
| :---------------- | :---------------------------------- | :--------------------------------- |
| **Buyer**         | add buyer 1 & 2, buyer list         | Add, Update, View buyers.          |
| **Order**         | order list, order details 1 & 2     | Create, View, Search orders.       |
| **BOM**           | BOM details by style code, BOM list | Generate, View, Update BOM.        |
| **Raw Materials** | calculation screens                 | Auto‑calculate required materials. |
| **UOM**           | UOM list                            | Manage types of measurement units. |

---

## 🔒 Access & Permissions

Only authorized **Merchandisers** can access this module. Data is restricted and securely handled using role‑based routing and backend validation.

---

## 📌 Notes

This documentation is based entirely on provided UI screenshots and reflects the Merchandising workflow of a Garments Management System (RMG).

---


<!-- production -->

# 🏭 Production Manager Module: Garments Management System (RMG)

This README provides a detailed overview of the **Production Manager Module** based on the provided UI screenshots. This module allows production teams to manage cutting plans, cut bundles, daily production records, machine info, and line-wise workflow efficiently.

---

## 🌟 Key Features

The Production Manager Module covers all essential production tracking and management tasks:

* **Cutting Plan Management:** Create, search, and view cutting plans.
* **Cut Bundle Management:** Add cut bundles and browse bundles by date or cutting plan.
* **Daily Production Tracking:** List and search daily production based on date or order.
* **Production Order Management:** View production order details with various filtering options.
* **Line & Machine Management:** Save and view production lines and machine information.
* **Production Dashboard & Profile:** Central dashboard for all production metrics with profile view.

---

## 🖼️ Module Screenshots Overview

Screenshot documentation path format: `screenshots/production manager/filename.PNG`.

| Screenshot                                     | File Name                                      | Preview                                                                                                   | Description                                       |
| :--------------------------------------------- | :--------------------------------------------- | :-------------------------------------------------------------------------------------------------------- | :------------------------------------------------ |
| **Add Cut Bundle**                             | `add cut bundle.PNG`                           | ![add cut bundle](screenshots/production%20manager/add%20cut%20bundle.PNG)                                | Create and store new cut bundle details.          |
| **Cut Bundle List (Search by Date)**           | `cut bundle list search by date.PNG`           | ![cut bundle list date](screenshots/production%20manager/cut%20bundle%20list%20search%20by%20date.PNG)    | Search existing cut bundles by date.              |
| **Cut Bundle List**                            | `cut bundle list.PNG`                          | ![cut bundle list](screenshots/production%20manager/cut%20bundle%20list.PNG)                              | Shows all available cut bundles.                  |
| **Cut Bundle Search by Cutting Plan ID**       | `cut bundle search by cutting plan ID.PNG`     | ![cut bundle cpID](screenshots/production%20manager/cut%20bundle%20search%20by%20cutting%20plan%20ID.PNG) | Search bundles linked to a specific cutting plan. |
| **Cutting Plan List**                          | `cutting plan list.PNG`                        | ![cutting list](screenshots/production%20manager/cutting%20plan%20list.PNG)                               | Displays all cutting plans.                       |
| **Cutting Plan Search by Date**                | `cutting plan search by date.PNG`              | ![cutting search date](screenshots/production%20manager/cutting%20plan%20search%20by%20date.PNG)          | Search cutting plans using date filters.          |
| **Day-wise Production List**                   | `day wise production list.PNG`                 | ![dwp list](screenshots/production%20manager/day%20wise%20production%20list.PNG)                          | View day-by-day production output.                |
| **Day-wise Production Search by Date**         | `day wise production search by date.PNG`       | ![dwp search date](screenshots/production%20manager/day%20wise%20production%20search%20by%20date.PNG)     | Filter day-wise output by date.                   |
| **Day-wise Production Search by Order ID**     | `day wise production search by order ID.PNG`   | ![dwp order](screenshots/production%20manager/day%20wise%20production%20search%20by%20order%20ID.PNG)     | Search production records by order ID.            |
| **Line Save & View**                           | `line save and view.PNG`                       | ![line view](screenshots/production%20manager/line%20save%20and%20view.PNG)                               | Add and view production line details.             |
| **Machine Add & View**                         | `machine add and view.PNG`                     | ![machine view](screenshots/production%20manager/machine%20add%20and%20view.PNG)                          | Manage sewing or production machines.             |
| **Production Manager Dashboard**               | `production manager dashboard.PNG`             | ![dashboard](screenshots/production%20manager/production%20manager%20dashboard.PNG)                       | Centralized dashboard overview.                   |
| **Production Manager Profile**                 | `production manager profile.PNG`               | ![profile](screenshots/production%20manager/production%20manager%20profile.PNG)                           | Profile details of the production manager.        |
| **Production Order List (Search by Date)**     | `production order list search by date.PNG`     | ![pol date](screenshots/production%20manager/production%20order%20list%20search%20by%20date.PNG)          | Filter production orders using a date range.      |
| **Production Order List (Search by Order ID)** | `production order list search by order ID.PNG` | ![pol id](screenshots/production%20manager/production%20order%20list%20search%20by%20order%20ID.PNG)      | Search production orders by order ID.             |
| **Production Order List**                      | `production order list.PNG`                    | ![pol](screenshots/production%20manager/production%20order%20list.PNG)                                    | View all production orders in the system.         |

---

## ⚙️ Technical Structure

| Entity                 | Related Screens                   | Operations                       |
| :--------------------- | :-------------------------------- | :------------------------------- |
| **Cutting Plan**       | cutting plan list, search by date | Create, Read, Filter.            |
| **Cut Bundle**         | add cut bundle, bundle lists      | Add, View, Search.               |
| **Daily Production**   | day-wise screens                  | Log, View, Search by date/order. |
| **Production Order**   | order list variations             | Track, View, Filter orders.      |
| **Line Management**    | line save & view                  | Create, Manage lines.            |
| **Machine Management** | machine add & view                | Add and manage machine info.     |

---

## 🔒 Access & Permissions

Only users assigned the role of **Production Manager** have access to this module. Data operations are restricted using role-based authorization.

---

## 📌 Notes

This documentation is fully based on the provided screenshots and represents the workflow followed by a production department in a Garments Management System.

---
<!-- purchase -->

# 🛒 Purchase Manager Module: Garments Management System (RMG)

This README provides a detailed overview of the **Purchase Manager Module** based on the provided UI screenshots. This module handles vendor management, purchase requisitions, item inventory, and purchase orders—ensuring smooth procurement operations in a Garments Production Environment.

---

## 🌟 Key Features

The Purchase Manager Module streamlines all procurement activities:

* **Vendor Management:** Add vendors, view vendor details, and maintain supplier records.
* **Item & Inventory Management:** Manage item lists and inventory details.
* **Purchase Requisition Processing:** View and analyze requisition requests sent by departments.
* **Purchase Order Management:** Create, view, and verify purchase orders.
* **Dashboard & Profile:** Quick access to all purchase workflows and user profile.

---

## 🖼️ Module Screenshots Overview

Screenshots follow the structure: `screenshots/purchase manager/filename.PNG`.

| Screenshot                     | File Name                        | Preview                                                                         | Description                                       |
| :----------------------------- | :------------------------------- | :------------------------------------------------------------------------------ | :------------------------------------------------ |
| **Add Vendor (Form 1)**        | `add vendor 1.PNG`               | ![add vendor 1](screenshots/purchase%20manager/add%20vendor%201.PNG)            | Basic vendor details entry screen.                |
| **Add Vendor (Form 2)**        | `add vendor 2.PNG`               | ![add vendor 2](screenshots/purchase%20manager/add%20vendor%202.PNG)            | Additional vendor information submission.         |
| **Inventory Overview**         | `inventory.PNG`                  | ![inventory](screenshots/purchase%20manager/inventory.PNG)                      | Shows material inventory categories.              |
| **Item List**                  | `item list.PNG`                  | ![item list](screenshots/purchase%20manager/item%20list.PNG)                    | List of items used in procurement.                |
| **PO Details (Screen 1)**      | `PO details 1.PNG`               | ![po details 1](screenshots/purchase%20manager/PO%20details%201.PNG)            | Displays primary purchase order details.          |
| **PO Details (Screen 2)**      | `PO details 2.PNG`               | ![po details 2](screenshots/purchase%20manager/PO%20details%202.PNG)            | Extended item/quantity information of a PO.       |
| **PO List**                    | `PO list.PNG`                    | ![po list](screenshots/purchase%20manager/PO%20list.PNG)                        | View all purchase orders in the system.           |
| **Purchase Manager Dashboard** | `purchase manager dashboard.PNG` | ![dashboard](screenshots/purchase%20manager/purchase%20manager%20dashboard.PNG) | Main hub for procurement tasks.                   |
| **Purchase Manager Profile**   | `purchase manager profile.PNG`   | ![profile](screenshots/purchase%20manager/purchase%20manager%20profile.PNG)     | View/update purchase manager information.         |
| **Requisition Details**        | `requisition details.PNG`        | ![req details](screenshots/purchase%20manager/requisition%20details.PNG)        | Shows item quantity and approval status.          |
| **Requisition List**           | `requisition list.PNG`           | ![req list](screenshots/purchase%20manager/requisition%20list.PNG)              | Displays all requisition requests.                |
| **Save Item**                  | `save item.PNG`                  | ![save item](screenshots/purchase%20manager/save%20item.PNG)                    | Add new item to inventory.                        |
| **Vendor Details**             | `vendor details.PNG`             | ![vendor details](screenshots/purchase%20manager/vendor%20details.PNG)          | Shows complete information for a selected vendor. |
| **Vendor List**                | `vendor list.PNG`                | ![vendor list](screenshots/purchase%20manager/vendor%20list.PNG)                | List of all registered vendors.                   |

---

## ⚙️ Technical Structure

| Entity                  | Related Screens                                 | Main Operations                         |
| :---------------------- | :---------------------------------------------- | :-------------------------------------- |
| **Vendor**              | add vendor screens, vendor list, vendor details | Create, View, Update vendor info.       |
| **Item**                | item list, save item                            | Add, Edit, Manage item details.         |
| **Inventory**           | inventory overview                              | Track material categories.              |
| **Requisition**         | requisition list, requisition details           | Review, Approve, Reject requests.       |
| **Purchase Order (PO)** | PO list, PO details                             | Create POs, Review quantities, Approve. |

---

## 🔒 Access & Permissions

Only users assigned the **Purchase Manager** role can access this module. Operations such as PO approval and vendor registration are secure and role-restricted.

---

## 📌 Notes

This README is entirely based on the provided UI screenshots and reflects the procurement workflow in a modern Garments Management System.

---
