create table addresses
(
    id            bigint auto_increment comment 'Mã định danh duy nhất của địa chỉ'
        primary key,
    address_type  varchar(50)                            not null comment 'Loại địa chỉ (giao hàng, lấy hàng, trả hàng)',
    address       varchar(500)                           not null comment 'Địa chỉ đầy đủ (số nhà, đường, phường/xã)',
    latitude      decimal(10, 8)                         null comment 'Tọa độ vĩ độ (GPS)',
    longitude     decimal(11, 8)                         null comment 'Tọa độ kinh độ (GPS)',
    city          varchar(100)                           null comment 'Thành phố/Tỉnh',
    state         varchar(100)                           null comment 'Bang/Khu vực',
    country       varchar(100) default 'Vietnam'         null comment 'Quốc gia',
    region        varchar(100)                           null comment 'Vùng miền/Khu vực',
    postal_code   varchar(20)                            null comment 'Mã bưu điện',
    contact_name  varchar(255)                           null comment 'Tên người liên hệ tại địa chỉ',
    contact_phone varchar(20)                            null comment 'Số điện thoại người liên hệ',
    contact_email varchar(255)                           null comment 'Email người liên hệ',
    floor_number  varchar(10)                            null comment 'Số tầng/lầu của tòa nhà',
    created_at    datetime     default CURRENT_TIMESTAMP null comment 'Thời gian tạo địa chỉ',
    updated_at    datetime     default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật địa chỉ cuối cùng'
);

create index idx_addresses_city
    on addresses (city)
    comment 'Địa chỉ theo thành phố';

create index idx_addresses_coordinates
    on addresses (latitude, longitude)
    comment 'Tìm kiếm theo tọa độ GPS';

create index idx_addresses_type
    on addresses (address_type)
    comment 'Địa chỉ theo loại';

create table categories
(
    id          bigint auto_increment comment 'Mã định danh duy nhất của danh mục'
        primary key,
    external_id bigint                             null,
    category_id varchar(50)                        not null comment 'Mã danh mục nghiệp vụ (dễ đọc)',
    name        varchar(255)                       not null comment 'Tên hiển thị của danh mục',
    description text                               null comment 'Mô tả chi tiết về danh mục',
    parent_id   bigint                             null comment 'ID danh mục cha (cho cấu trúc cây)',
    is_active   bit                                null,
    created_at  datetime default CURRENT_TIMESTAMP null comment 'Thời gian tạo danh mục',
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật danh mục cuối cùng',
    notes       text                               null comment 'Ghi chú bổ sung về danh mục',
    constraint category_id
        unique (category_id),
    constraint external_id
        unique (external_id),
    constraint fk_categories_parent_id
        foreign key (parent_id) references categories (id)
);

create index idx_categories_active
    on categories (is_active)
    comment 'Danh mục đang hoạt động';

create index idx_categories_category_id
    on categories (category_id)
    comment 'Tìm theo mã danh mục';

create index idx_categories_parent
    on categories (parent_id)
    comment 'Danh mục theo danh mục cha';

create table products_backup_20250811_102144
(
    id             bigint         default 0                 not null comment 'Mã định danh duy nhất của sản phẩm',
    external_id    bigint                                   null,
    product_code   varchar(50)                              not null comment 'Mã SKU/mã nội bộ sản phẩm',
    name           varchar(255)                             not null comment 'Tên hiển thị sản phẩm',
    description    text                                     null comment 'Mô tả chi tiết sản phẩm',
    category_id    bigint                                   not null comment 'Phân loại danh mục sản phẩm',
    unit_price     decimal(15, 2)                           not null comment 'Giá bán trên một đơn vị',
    weight         decimal(10, 3) default 0.000             null comment 'Trọng lượng sản phẩm (kg)',
    volume         decimal(10, 3) default 0.000             null comment 'Thể tích sản phẩm (m3)',
    is_fragile     tinyint        default 0                 not null,
    stock_quantity int            default 0                 not null comment 'Số lượng tồn kho hiện tại',
    product_image  varchar(500)                             null comment 'URL/đường dẫn ảnh sản phẩm',
    product_status enum ('ACTIVE', 'INACTIVE')              not null,
    warehouse_id   bigint                                   null comment 'Kho chính chứa sản phẩm này',
    created_at     datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo sản phẩm',
    updated_at     datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật sản phẩm cuối cùng',
    created_by     bigint                                   null comment 'ID người dùng tạo sản phẩm này',
    notes          text                                     null comment 'Ghi chú bổ sung về sản phẩm'
);

create table products_backup_20250811_102215
(
    id             bigint         default 0                 not null comment 'Mã định danh duy nhất của sản phẩm',
    external_id    bigint                                   null,
    product_code   varchar(50)                              not null comment 'Mã SKU/mã nội bộ sản phẩm',
    name           varchar(255)                             not null comment 'Tên hiển thị sản phẩm',
    description    text                                     null comment 'Mô tả chi tiết sản phẩm',
    category_id    bigint                                   not null comment 'Phân loại danh mục sản phẩm',
    unit_price     decimal(15, 2)                           not null comment 'Giá bán trên một đơn vị',
    weight         decimal(10, 3) default 0.000             null comment 'Trọng lượng sản phẩm (kg)',
    volume         decimal(10, 3) default 0.000             null comment 'Thể tích sản phẩm (m3)',
    is_fragile     tinyint        default 0                 not null,
    stock_quantity int            default 0                 not null comment 'Số lượng tồn kho hiện tại',
    product_image  varchar(500)                             null comment 'URL/đường dẫn ảnh sản phẩm',
    product_status enum ('ACTIVE', 'INACTIVE')              not null,
    warehouse_id   bigint                                   null comment 'Kho chính chứa sản phẩm này',
    created_at     datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo sản phẩm',
    updated_at     datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật sản phẩm cuối cùng',
    created_by     bigint                                   null comment 'ID người dùng tạo sản phẩm này',
    notes          text                                     null comment 'Ghi chú bổ sung về sản phẩm'
);

create table products_backup_20250811_102245
(
    id             bigint         default 0                 not null comment 'Mã định danh duy nhất của sản phẩm',
    external_id    bigint                                   null,
    product_code   varchar(50)                              not null comment 'Mã SKU/mã nội bộ sản phẩm',
    name           varchar(255)                             not null comment 'Tên hiển thị sản phẩm',
    description    text                                     null comment 'Mô tả chi tiết sản phẩm',
    category_id    bigint                                   not null comment 'Phân loại danh mục sản phẩm',
    unit_price     decimal(15, 2)                           not null comment 'Giá bán trên một đơn vị',
    weight         decimal(10, 3) default 0.000             null comment 'Trọng lượng sản phẩm (kg)',
    volume         decimal(10, 3) default 0.000             null comment 'Thể tích sản phẩm (m3)',
    is_fragile     tinyint        default 0                 not null,
    stock_quantity int            default 0                 not null comment 'Số lượng tồn kho hiện tại',
    product_image  varchar(500)                             null comment 'URL/đường dẫn ảnh sản phẩm',
    product_status enum ('ACTIVE', 'INACTIVE')              not null,
    warehouse_id   bigint                                   null comment 'Kho chính chứa sản phẩm này',
    created_at     datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo sản phẩm',
    updated_at     datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật sản phẩm cuối cùng',
    created_by     bigint                                   null comment 'ID người dùng tạo sản phẩm này',
    notes          text                                     null comment 'Ghi chú bổ sung về sản phẩm'
);

create table products_backup_20250811_102313
(
    id             bigint         default 0                 not null comment 'Mã định danh duy nhất của sản phẩm',
    external_id    bigint                                   null,
    product_code   varchar(50)                              not null comment 'Mã SKU/mã nội bộ sản phẩm',
    name           varchar(255)                             not null comment 'Tên hiển thị sản phẩm',
    description    text                                     null comment 'Mô tả chi tiết sản phẩm',
    category_id    bigint                                   not null comment 'Phân loại danh mục sản phẩm',
    unit_price     decimal(15, 2)                           not null comment 'Giá bán trên một đơn vị',
    weight         decimal(10, 3) default 0.000             null comment 'Trọng lượng sản phẩm (kg)',
    volume         decimal(10, 3) default 0.000             null comment 'Thể tích sản phẩm (m3)',
    is_fragile     tinyint        default 0                 not null,
    stock_quantity int            default 0                 not null comment 'Số lượng tồn kho hiện tại',
    product_image  varchar(500)                             null comment 'URL/đường dẫn ảnh sản phẩm',
    product_status enum ('ACTIVE', 'INACTIVE')              not null,
    warehouse_id   bigint                                   null comment 'Kho chính chứa sản phẩm này',
    created_at     datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo sản phẩm',
    updated_at     datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật sản phẩm cuối cùng',
    created_by     bigint                                   null comment 'ID người dùng tạo sản phẩm này',
    notes          text                                     null comment 'Ghi chú bổ sung về sản phẩm'
);

create table roles
(
    id          bigint auto_increment comment 'Mã định danh duy nhất của vai trò'
        primary key,
    role_name   varchar(50)                        not null comment 'Tên vai trò (admin, điều phối, tài xế, xem)',
    permission  json                               null comment 'Đối tượng JSON chứa quyền và quyền truy cập của vai trò',
    description text                               null comment 'Mô tả chi tiết trách nhiệm của vai trò',
    is_active   bit                                not null,
    created_at  datetime default CURRENT_TIMESTAMP null comment 'Thời gian tạo vai trò',
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật vai trò cuối cùng',
    constraint role_name
        unique (role_name)
);

create index idx_roles_active
    on roles (is_active)
    comment 'Vai trò đang hoạt động';

create index idx_roles_name
    on roles (role_name)
    comment 'Tìm vai trò theo tên';

create table status
(
    id          tinyint unsigned auto_increment comment 'Mã định danh trạng thái duy nhất (1-255)'
        primary key,
    type        varchar(50)                        not null comment 'Phân loại trạng thái (phương tiện, đơn hàng, thanh toán, người dùng, v.v.)',
    name        varchar(100)                       not null comment 'Tên trạng thái dễ đọc',
    description text                               null comment 'Mô tả chi tiết ý nghĩa của trạng thái',
    created_at  datetime default CURRENT_TIMESTAMP null comment 'Thời gian tạo trạng thái',
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật trạng thái cuối cùng'
);

create index idx_status_name
    on status (name)
    comment 'Tìm trạng thái theo tên';

create index idx_status_type
    on status (type)
    comment 'Trạng thái theo loại';

create table users
(
    id          bigint auto_increment comment 'Mã định danh duy nhất của người dùng'
        primary key,
    external_id bigint                             null,
    username    varchar(100)                       not null comment 'Tên đăng nhập duy nhất',
    email       varchar(255)                       not null comment 'Địa chỉ email để đăng nhập và nhận thông báo',
    password    varchar(255)                       not null comment 'Mật khẩu đã mã hóa để xác thực',
    full_name   varchar(255)                       null comment 'Họ tên đầy đủ để hiển thị',
    phone       varchar(20)                        null comment 'Số điện thoại liên hệ',
    role_id     bigint                             not null comment 'Vai trò người dùng (admin, điều phối, tài xế, xem)',
    status_id   tinyint unsigned                   null comment 'Trạng thái tài khoản (hoạt động, ngừng hoạt động, tạm khóa)',
    created_at  datetime default CURRENT_TIMESTAMP null comment 'Thời gian tạo tài khoản',
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật tài khoản cuối cùng',
    notes       text                               null comment 'Ghi chú bổ sung về người dùng',
    google_id   varchar(100)                       null,
    constraint email
        unique (email),
    constraint external_id
        unique (external_id),
    constraint username
        unique (username),
    constraint fk_users_role_id
        foreign key (role_id) references roles (id),
    constraint fk_users_status_id
        foreign key (status_id) references status (id)
);

create table activity_logs
(
    id               bigint auto_increment comment 'Mã định danh duy nhất của nhật ký hoạt động'
        primary key,
    actor_id         bigint                             null comment 'ID người dùng thực hiện hành động',
    role_id          bigint                             not null comment 'Vai trò của người dùng tại thời điểm thực hiện',
    status_id        tinyint unsigned                   not null comment 'Trạng thái hoàn thành hành động',
    action_type      varchar(50)                        not null comment 'Loại hành động (TẠO, CẬP NHẬT, XÓA, ĐĂNG NHẬP, v.v.)',
    table_name       varchar(255)                       null,
    record_id        bigint                             null comment 'ID của bản ghi bị ảnh hưởng',
    action_timestamp datetime default CURRENT_TIMESTAMP not null comment 'Thời điểm xảy ra hành động',
    metadata         json                               null comment 'Metadata bổ sung (giá trị cũ/mới, IP, v.v.)',
    constraint FK5wnh8r1e5ffup2wu2shpwywak
        foreign key (actor_id) references users (id)
            on delete cascade,
    constraint fk_activity_logs_role_id
        foreign key (role_id) references roles (id),
    constraint fk_activity_logs_status_id
        foreign key (status_id) references status (id)
);

create index idx_activity_logs_action_time
    on activity_logs (action_timestamp desc)
    comment 'Log theo thời gian hành động';

create index idx_activity_logs_action_type
    on activity_logs (action_type)
    comment 'Log theo loại hành động';

create index idx_activity_logs_actor
    on activity_logs (actor_id)
    comment 'Log theo người thực hiện';

create index idx_activity_logs_record
    on activity_logs (table_name, record_id)
    comment 'Log theo bản ghi cụ thể';

create index idx_activity_logs_table
    on activity_logs (table_name)
    comment 'Log theo bảng bị ảnh hưởng';

create table routes
(
    id                         bigint auto_increment comment 'Mã định danh duy nhất của tuyến đường'
        primary key,
    name                       varchar(255)                             not null comment 'Tên tuyến đường (mô tả ngắn)',
    waypoints                  json                                     not null comment 'Danh sách các điểm dừng trên tuyến (JSON)',
    estimated_distance_km      decimal(10, 2) default 0.00              null comment 'Khoảng cách dự kiến (km)',
    estimated_duration_minutes int            default 0                 null comment 'Thời gian dự kiến (phút)',
    estimated_cost             decimal(15, 2) default 0.00              null comment 'Chi phí dự kiến cho tuyến',
    created_at                 datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo tuyến đường',
    updated_at                 datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật tuyến cuối cùng',
    completed_at               datetime                                 null comment 'Thời gian hoàn thành tuyến đường',
    created_by                 bigint                                   null comment 'ID người dùng tạo tuyến đường',
    notes                      text                                     null comment 'Ghi chú bổ sung về tuyến đường',
    constraint fk_routes_created_by
        foreign key (created_by) references users (id)
);

create index idx_routes_completed
    on routes (completed_at)
    comment 'Tuyến đường đã hoàn thành';

create index idx_routes_created_by
    on routes (created_by)
    comment 'Tuyến đường theo người tạo';

create index idx_routes_estimated_cost
    on routes (estimated_cost)
    comment 'Sắp xếp theo chi phí dự kiến';

create table stores
(
    id          bigint auto_increment comment 'Mã định danh duy nhất của cửa hàng'
        primary key,
    external_id bigint                             null,
    store_name  varchar(255)                       not null comment 'Tên hiển thị của cửa hàng',
    email       varchar(255)                       null comment 'Email liên hệ của cửa hàng',
    phone       varchar(20)                        not null comment 'Số điện thoại liên hệ cửa hàng',
    address     text                               not null comment 'Địa chỉ đầy đủ của cửa hàng',
    latitude    decimal(10, 8)                     null comment 'Tọa độ vĩ độ cửa hàng',
    longitude   decimal(11, 8)                     null comment 'Tọa độ kinh độ cửa hàng',
    is_active   bit                                null,
    created_at  datetime default CURRENT_TIMESTAMP null comment 'Thời gian tạo cửa hàng',
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật cửa hàng cuối cùng',
    created_by  bigint                             null comment 'ID người dùng tạo cửa hàng này',
    notes       text                               null comment 'Ghi chú bổ sung về cửa hàng',
    constraint external_id
        unique (external_id),
    constraint fk_stores_created_by
        foreign key (created_by) references users (id)
);

create table orders
(
    id                     bigint auto_increment comment 'Mã định danh duy nhất của đơn hàng'
        primary key,
    external_id            bigint                                   null,
    status_id              tinyint unsigned                         not null comment 'Trạng thái đơn hàng (chờ xử lý, đang xử lý, hoàn thành, hủy)',
    store_id               bigint                                   null comment 'ID cửa hàng liên kết, NULL cho đơn hàng online',
    description            text                                     null comment 'Mô tả và chi tiết đơn hàng',
    total_amount           decimal(15, 2) default 0.00              null comment 'Tổng số tiền đơn hàng bao gồm phí',
    benefit_per_order      decimal(15, 2) default 0.00              null comment 'Lợi nhuận/biên lãi dự kiến từ đơn hàng này',
    order_profit_per_order decimal(15, 2) default 0.00              null comment 'Lợi nhuận được tính toán cho đơn hàng này',
    notes                  text                                     null comment 'Ghi chú bổ sung về đơn hàng',
    created_at             datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo đơn hàng',
    updated_at             datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật đơn hàng cuối cùng',
    created_by             bigint                                   null comment 'ID người dùng tạo đơn hàng này',
    address_id             bigint                                   null,
    constraint external_id
        unique (external_id),
    constraint FKhlglkvf5i60dv6dn397ethgpt
        foreign key (address_id) references addresses (id),
    constraint fk_orders_created_by
        foreign key (created_by) references users (id),
    constraint fk_orders_status_id
        foreign key (status_id) references status (id),
    constraint fk_orders_store_id
        foreign key (store_id) references stores (id)
);

create table delivery_proofs
(
    id                  bigint auto_increment comment 'Mã định danh duy nhất của bằng chứng giao hàng'
        primary key,
    proof_type          varchar(50) default 'PHOTO'           not null comment 'Loại bằng chứng (ảnh, chữ ký, ghi âm)',
    file_path           varchar(255)                          null,
    file_name           varchar(255)                          null comment 'Tên file bằng chứng gốc',
    recipient_name      varchar(255)                          null comment 'Tên người nhận hàng thực tế',
    recipient_signature varchar(255)                          null,
    captured_at         datetime                              null comment 'Thời gian chụp/ghi nhận bằng chứng',
    created_at          datetime    default CURRENT_TIMESTAMP null comment 'Thời gian tạo bản ghi bằng chứng',
    order_id            bigint                                not null comment 'Mã đơn hàng liên quan đến bằng chứng',
    uploaded_by         bigint                                null comment 'ID người dùng (tài xế) upload bằng chứng',
    notes               text                                  null comment 'Ghi chú bổ sung về bằng chứng giao hàng',
    constraint fk_delivery_proofs_order_id
        foreign key (order_id) references orders (id),
    constraint fk_delivery_proofs_uploaded_by
        foreign key (uploaded_by) references users (id)
);

create index idx_delivery_proofs_captured
    on delivery_proofs (captured_at desc)
    comment 'Bằng chứng theo thời gian chụp';

create index idx_delivery_proofs_order
    on delivery_proofs (order_id)
    comment 'Bằng chứng theo đơn hàng';

create index idx_delivery_proofs_type
    on delivery_proofs (proof_type)
    comment 'Bằng chứng theo loại';

create index idx_delivery_proofs_uploader
    on delivery_proofs (uploaded_by)
    comment 'Bằng chứng theo người upload';

create index idx_orders_created_by
    on orders (created_by)
    comment 'Tìm đơn hàng theo người tạo';

create index idx_orders_status
    on orders (status_id)
    comment 'Tìm đơn hàng theo trạng thái';

create index idx_orders_status_created
    on orders (status_id, created_at)
    comment 'Sắp xếp đơn hàng theo trạng thái và thời gian';

create index idx_orders_store
    on orders (store_id)
    comment 'Tìm đơn hàng theo cửa hàng';

create table payments
(
    id             bigint auto_increment comment 'Mã định danh duy nhất của thanh toán'
        primary key,
    order_id       bigint                                not null comment 'Mã đơn hàng được thanh toán',
    amount         decimal(15, 2)                        not null comment 'Tổng số tiền thanh toán',
    payment_method varchar(50) default 'CASH'            not null comment 'Phương thức thanh toán (tiền mặt, thẻ, chuyển khoản)',
    status_id      tinyint unsigned                      not null comment 'Trạng thái thanh toán (thành công, thất bại, chờ xử lý)',
    transaction_id varchar(255)                          null comment 'Mã giao dịch từ cổng thanh toán',
    created_at     datetime    default CURRENT_TIMESTAMP null comment 'Thời gian tạo bản ghi thanh toán',
    updated_at     datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật thanh toán cuối cùng',
    created_by     bigint                                null comment 'ID người dùng tạo bản ghi thanh toán',
    notes          text                                  null comment 'Ghi chú bổ sung về thanh toán',
    constraint fk_payments_created_by
        foreign key (created_by) references users (id),
    constraint fk_payments_order_id
        foreign key (order_id) references orders (id),
    constraint fk_payments_status_id
        foreign key (status_id) references status (id),
    constraint chk_payment_amount
        check (`amount` > 0)
);

create index idx_payments_created
    on payments (created_at desc)
    comment 'Thanh toán theo thời gian tạo';

create index idx_payments_method
    on payments (payment_method)
    comment 'Thanh toán theo phương thức';

create index idx_payments_order
    on payments (order_id)
    comment 'Thanh toán theo đơn hàng';

create index idx_payments_status
    on payments (status_id)
    comment 'Thanh toán theo trạng thái';

create index idx_payments_transaction
    on payments (transaction_id)
    comment 'Thanh toán theo mã giao dịch';

create index idx_stores_active
    on stores (is_active)
    comment 'Cửa hàng đang hoạt động';

create index idx_stores_coordinates
    on stores (latitude, longitude)
    comment 'Tìm cửa hàng theo tọa độ';

create index idx_users_email
    on users (email)
    comment 'Tìm người dùng theo email';

create index idx_users_role
    on users (role_id)
    comment 'Người dùng theo vai trò';

create index idx_users_status
    on users (status_id)
    comment 'Người dùng theo trạng thái';

create index idx_users_username
    on users (username)
    comment 'Tìm người dùng theo username';

create table vehicles
(
    id                 bigint auto_increment comment 'Mã định danh duy nhất của phương tiện'
        primary key,
    license_plate      varchar(20)                              not null comment 'Biển số xe',
    vehicle_type       varchar(50)    default 'TRUCK'           not null comment 'Loại phương tiện (xe tải, xe van, xe máy, ô tô)',
    capacity_weight_kg decimal(10, 2) default 0.00              null comment 'Trọng tải tối đa của phương tiện (kg)',
    capacity_volume_m3 decimal(10, 2) default 0.00              null comment 'Thể tích chứa hàng tối đa (m3)',
    status_id          tinyint unsigned                         not null comment 'Trạng thái xe (hoạt động, bảo trì, ngừng hoạt động)',
    current_driver_id  bigint                                   null comment 'ID tài xế hiện tại, NULL nếu chưa phân công',
    created_at         datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo bản ghi',
    updated_at         datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật cuối cùng',
    notes              text                                     null comment 'Ghi chú bổ sung về phương tiện',
    constraint license_plate
        unique (license_plate),
    constraint fk_vehicles_current_driver_id
        foreign key (current_driver_id) references users (id),
    constraint fk_vehicles_status_id
        foreign key (status_id) references status (id),
    constraint chk_vehicle_capacity
        check ((`capacity_weight_kg` >= 0) and (`capacity_volume_m3` >= 0))
);

create table deliveries
(
    id                     bigint auto_increment comment 'Mã định danh duy nhất của giao hàng'
        primary key,
    order_id               bigint                                not null comment 'Đơn hàng liên kết đang được giao',
    delivery_fee           decimal(38, 2)                        null,
    transport_mode         varchar(50) default 'ROAD'            null comment 'Phương thức vận chuyển (đường bộ, hàng không, đường biển, đường sắt)',
    service_type           varchar(50) default 'STANDARD'        null comment 'Mức dịch vụ (tiêu chuẩn, nhanh, ưu tiên)',
    order_date             datetime                              not null comment 'Thời điểm đặt hàng',
    pickup_date            datetime                              null comment 'Thời điểm lấy hàng',
    schedule_delivery_time datetime                              null comment 'Thời gian giao hàng dự kiến',
    actual_delivery_time   datetime                              null comment 'Thời gian hoàn thành giao hàng thực tế',
    late_delivery_risk     int                                   not null,
    vehicle_id             bigint                                not null comment 'Phương tiện được phân công cho giao hàng này',
    driver_id              bigint                                null comment 'Tài xế được phân công cho giao hàng này',
    tracking_id            bigint                                null comment 'Bản ghi theo dõi GPS cho giao hàng này',
    route_id               bigint                                null comment 'Tuyến đường tối ưu cho giao hàng này',
    delivery_attempts      int         default 0                 null comment 'Số lần thử giao hàng đã thực hiện',
    delivery_notes         text                                  null comment 'Hướng dẫn đặc biệt và ghi chú cho giao hàng',
    created_at             datetime    default CURRENT_TIMESTAMP null comment 'Thời gian tạo bản ghi giao hàng',
    updated_at             datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật bản ghi giao hàng cuối cùng',
    constraint fk_deliveries_driver_id
        foreign key (driver_id) references users (id),
    constraint fk_deliveries_order_id
        foreign key (order_id) references orders (id),
    constraint fk_deliveries_route_id
        foreign key (route_id) references routes (id),
    constraint fk_deliveries_vehicle_id
        foreign key (vehicle_id) references vehicles (id),
    constraint chk_delivery_attempts
        check (`delivery_attempts` >= 0)
);

create index idx_deliveries_driver
    on deliveries (driver_id)
    comment 'Tìm giao hàng theo tài xế';

create index idx_deliveries_order
    on deliveries (order_id)
    comment 'Tìm giao hàng theo đơn hàng';

create index idx_deliveries_route
    on deliveries (route_id)
    comment 'Tìm giao hàng theo tuyến đường';

create index idx_deliveries_schedule_time
    on deliveries (schedule_delivery_time)
    comment 'Sắp xếp theo thời gian giao hàng dự kiến';

create index idx_deliveries_tracking
    on deliveries (tracking_id)
    comment 'Tìm giao hàng theo tracking';

create index idx_deliveries_vehicle
    on deliveries (vehicle_id)
    comment 'Tìm giao hàng theo phương tiện';

create table delivery_tracking
(
    id          bigint auto_increment comment 'Mã định danh duy nhất của điểm theo dõi'
        primary key,
    vehicle_id  bigint                             not null comment 'Mã phương tiện đang được theo dõi',
    status_id   tinyint unsigned                   not null comment 'Trạng thái giao hàng tại thời điểm này',
    latitude    decimal(10, 8)                     null comment 'Tọa độ vĩ độ hiện tại',
    longitude   decimal(11, 8)                     null comment 'Tọa độ kinh độ hiện tại',
    timestamp   datetime default CURRENT_TIMESTAMP not null comment 'Thời gian ghi nhận điểm theo dõi',
    location    varchar(255)                       null comment 'Tên địa điểm hiện tại (dễ đọc)',
    notes       text                               null comment 'Ghi chú bổ sung tại điểm theo dõi',
    created_at  datetime default CURRENT_TIMESTAMP null comment 'Thời gian tạo bản ghi theo dõi',
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật bản ghi cuối cùng',
    delivery_id bigint                             not null,
    constraint FKa7752nojalt7df2ssnia9er56
        foreign key (delivery_id) references deliveries (id),
    constraint fk_delivery_tracking_status_id
        foreign key (status_id) references status (id),
    constraint fk_delivery_tracking_vehicle_id
        foreign key (vehicle_id) references vehicles (id)
);

alter table deliveries
    add constraint fk_deliveries_tracking_id
        foreign key (tracking_id) references delivery_tracking (id);

create index idx_delivery_tracking_status
    on delivery_tracking (status_id)
    comment 'Tracking theo trạng thái';

create index idx_delivery_tracking_timestamp
    on delivery_tracking (timestamp desc)
    comment 'Sắp xếp tracking theo thời gian';

create index idx_delivery_tracking_vehicle
    on delivery_tracking (vehicle_id)
    comment 'Tracking theo phương tiện';

create index idx_delivery_tracking_vehicle_time
    on delivery_tracking (vehicle_id asc, timestamp desc)
    comment 'Tracking theo thời gian mới nhất';

create index idx_vehicles_driver
    on vehicles (current_driver_id)
    comment 'Phương tiện theo tài xế hiện tại';

create index idx_vehicles_license
    on vehicles (license_plate)
    comment 'Phương tiện theo biển số';

create index idx_vehicles_status
    on vehicles (status_id)
    comment 'Phương tiện theo trạng thái';

create index idx_vehicles_type
    on vehicles (vehicle_type)
    comment 'Phương tiện theo loại';

create table warehouses
(
    id             bigint auto_increment comment 'Mã định danh duy nhất của kho bãi'
        primary key,
    warehouse_code varchar(50)                              not null comment 'Mã kho nghiệp vụ (dễ đọc)',
    name           varchar(255)                             not null comment 'Tên hiển thị của kho bãi',
    address        text                                     not null comment 'Địa chỉ đầy đủ của kho bãi',
    latitude       decimal(10, 8)                           null comment 'Tọa độ vĩ độ kho bãi',
    longitude      decimal(11, 8)                           null comment 'Tọa độ kinh độ kho bãi',
    capacity_m3    decimal(10, 2) default 0.00              null comment 'Sức chứa tối đa của kho (m3)',
    is_active      bit                                      not null,
    created_at     datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo kho bãi',
    updated_at     datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật kho bãi cuối cùng',
    created_by     bigint                                   null comment 'ID người dùng tạo kho bãi này',
    notes          text                                     null comment 'Ghi chú bổ sung về kho bãi',
    constraint warehouse_code
        unique (warehouse_code),
    constraint fk_warehouses_created_by
        foreign key (created_by) references users (id)
);

create table products
(
    id             bigint auto_increment comment 'Mã định danh duy nhất của sản phẩm'
        primary key,
    external_id    bigint                                   null,
    product_code   varchar(50)                              not null comment 'Mã SKU/mã nội bộ sản phẩm',
    name           varchar(255)                             not null comment 'Tên hiển thị sản phẩm',
    description    text                                     null comment 'Mô tả chi tiết sản phẩm',
    category_id    bigint                                   not null comment 'Phân loại danh mục sản phẩm',
    unit_price     decimal(15, 2)                           not null comment 'Giá bán trên một đơn vị',
    weight         decimal(10, 3) default 0.000             null comment 'Trọng lượng sản phẩm (kg)',
    volume         decimal(10, 3) default 0.000             null comment 'Thể tích sản phẩm (m3)',
    is_fragile     tinyint        default 0                 not null,
    stock_quantity int            default 0                 not null comment 'Số lượng tồn kho hiện tại',
    product_image  varchar(500)                             null comment 'URL/đường dẫn ảnh sản phẩm',
    product_status enum ('ACTIVE', 'INACTIVE')              not null,
    warehouse_id   bigint                                   null comment 'Kho chính chứa sản phẩm này',
    created_at     datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo sản phẩm',
    updated_at     datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật sản phẩm cuối cùng',
    created_by     bigint                                   null comment 'ID người dùng tạo sản phẩm này',
    notes          text                                     null comment 'Ghi chú bổ sung về sản phẩm',
    constraint external_id
        unique (external_id),
    constraint product_code
        unique (product_code),
    constraint fk_products_category_id
        foreign key (category_id) references categories (id),
    constraint fk_products_created_by
        foreign key (created_by) references users (id),
    constraint fk_products_warehouse_id
        foreign key (warehouse_id) references warehouses (id),
    constraint chk_product_price_positive
        check (`unit_price` >= 0),
    constraint chk_product_weight_volume
        check ((`weight` >= 0) and (`volume` >= 0))
);

create table order_items
(
    id           bigint auto_increment comment 'Mã định danh duy nhất của mục hàng'
        primary key,
    external_id  bigint                             null,
    order_id     bigint                             not null comment 'Mã đơn hàng chứa mục hàng này',
    product_id   bigint                             not null comment 'Mã sản phẩm trong mục hàng',
    quantity     int                                not null comment 'Số lượng sản phẩm đặt mua',
    unit_price   decimal(38, 2)                     null,
    shipping_fee decimal(38, 2)                     null,
    created_at   datetime default CURRENT_TIMESTAMP null comment 'Thời gian tạo mục hàng',
    updated_at   datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment 'Thời gian cập nhật mục hàng cuối cùng',
    notes        text                               null comment 'Ghi chú đặc biệt cho mục hàng này',
    constraint external_id
        unique (external_id),
    constraint fk_order_items_order_id
        foreign key (order_id) references orders (id),
    constraint fk_order_items_product_id
        foreign key (product_id) references products (id),
    constraint chk_order_item_quantity
        check (`quantity` > 0)
);

create index idx_order_items_order
    on order_items (order_id)
    comment 'Tìm items theo đơn hàng';

create index idx_order_items_order_product
    on order_items (order_id, product_id)
    comment 'Composite index cho order-product';

create index idx_order_items_product
    on order_items (product_id)
    comment 'Tìm items theo sản phẩm';

create index idx_products_category
    on products (category_id)
    comment 'Tìm sản phẩm theo danh mục';

create index idx_products_code
    on products (product_code)
    comment 'Tìm sản phẩm theo mã SKU';

create index idx_products_status
    on products (product_status)
    comment 'Tìm sản phẩm theo trạng thái';

create index idx_products_warehouse
    on products (warehouse_id)
    comment 'Tìm sản phẩm theo kho';

create table warehouse_transactions
(
    id               bigint auto_increment comment 'Mã định danh duy nhất của giao dịch kho bãi'
        primary key,
    product_id       bigint                                   not null comment 'Mã sản phẩm tham gia giao dịch',
    warehouse_id     bigint                                   not null comment 'Mã kho hàng thực hiện giao dịch',
    status_id        tinyint unsigned                         not null comment 'Trạng thái giao dịch (thành công, thất bại, chờ xử lý)',
    transaction_type varchar(50)    default 'IN'              not null comment 'Loại giao dịch (nhập kho=IN, xuất kho=OUT, chuyển kho=TRANSFER)',
    quantity         int                                      not null comment 'Số lượng sản phẩm trong giao dịch',
    unit_cost        decimal(15, 2) default 0.00              null comment 'Giá vốn trên một đơn vị sản phẩm',
    transaction_date datetime       default CURRENT_TIMESTAMP null comment 'Thời gian thực hiện giao dịch kho bãi',
    order_id         bigint                                   null comment 'Mã đơn hàng liên quan (nếu có)',
    created_at       datetime       default CURRENT_TIMESTAMP null comment 'Thời gian tạo bản ghi giao dịch',
    created_by       bigint                                   null comment 'ID người dùng tạo giao dịch',
    notes            text                                     null comment 'Ghi chú bổ sung về giao dịch kho bãi',
    constraint fk_warehouse_transactions_created_by
        foreign key (created_by) references users (id),
    constraint fk_warehouse_transactions_order_id
        foreign key (order_id) references orders (id),
    constraint fk_warehouse_transactions_product_id
        foreign key (product_id) references products (id),
    constraint fk_warehouse_transactions_status_id
        foreign key (status_id) references status (id),
    constraint fk_warehouse_transactions_warehouse_id
        foreign key (warehouse_id) references warehouses (id)
);

create index idx_warehouse_trans_date
    on warehouse_transactions (transaction_date desc)
    comment 'Giao dịch theo thời gian';

create index idx_warehouse_trans_order
    on warehouse_transactions (order_id)
    comment 'Giao dịch theo đơn hàng';

create index idx_warehouse_trans_product
    on warehouse_transactions (product_id)
    comment 'Giao dịch theo sản phẩm';

create index idx_warehouse_trans_product_date
    on warehouse_transactions (product_id asc, transaction_date desc)
    comment 'Lịch sử giao dịch sản phẩm';

create index idx_warehouse_trans_type
    on warehouse_transactions (transaction_type)
    comment 'Giao dịch theo loại';

create index idx_warehouse_trans_warehouse
    on warehouse_transactions (warehouse_id)
    comment 'Giao dịch theo kho';

create index idx_warehouses_active
    on warehouses (is_active)
    comment 'Kho đang hoạt động';

create index idx_warehouses_code
    on warehouses (warehouse_code)
    comment 'Tìm kho theo mã';

create index idx_warehouses_coordinates
    on warehouses (latitude, longitude)
    comment 'Tìm kho theo tọa độ';


