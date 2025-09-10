
create table if not exists categories
(
    is_active   bit          null,
    created_at  datetime(6)  null,
    id          bigint auto_increment
        primary key,
    parent_id   bigint       null,
    updated_at  datetime(6)  null,
    description text         null,
    name        varchar(255) not null,
    notes       text         null,
    constraint FKsaok720gsu4u2wrgbk10b5n8d
        foreign key (parent_id) references categories (id)
);

create table if not exists roles
(
    is_active   bit         not null,
    created_at  datetime(6) null,
    id          bigint auto_increment
        primary key,
    updated_at  datetime(6) null,
    role_name   varchar(50) not null,
    description text        null,
    permission  json        null,
    constraint UK716hgxp60ym1lifrdgp67xt5k
        unique (role_name)
);

create table if not exists status
(
    id          smallint auto_increment
        primary key,
    created_at  datetime(6)                                  null,
    updated_at  datetime(6)                                  null,
    name        varchar(100)                                 null,
    description text                                         null,
    type        enum ('ORDER', 'PAYMENT', 'USER', 'VEHICLE') null
);

create table if not exists users
(
    status_id  smallint     null,
    created_at datetime(6)  null,
    id         bigint auto_increment
        primary key,
    role_id    bigint       not null,
    updated_at datetime(6)  null,
    phone      varchar(20)  null,
    google_id  varchar(100) null,
    username   varchar(100) not null,
    email      varchar(255) not null,
    full_name  varchar(255) null,
    notes      text         null,
    password   varchar(255) not null,
    constraint UK6dotkott2kjsp8vw4d0m25fb7
        unique (email),
    constraint UKr43af9ap4edm43mmtq01oddj6
        unique (username),
    constraint FK3m08uc0bd36m6tgp3g65m20dl
        foreign key (status_id) references status (id),
    constraint FKp56c1712k691lhsyewcssf40f
        foreign key (role_id) references roles (id)
);

create table if not exists activity_logs
(
    status_id        smallint                                               null,
    action_timestamp datetime(6)                                            null,
    actor_id         bigint                                                 null,
    id               bigint auto_increment
        primary key,
    record_id        bigint                                                 null,
    role_id          bigint                                                 null,
    metadata         json                                                   null,
    table_name       varchar(255)                                           null,
    action_type      enum ('CREATE', 'DELETE', 'LOGIN', 'LOGOUT', 'UPDATE') null,
    constraint FK5wnh8r1e5ffup2wu2shpwywak
        foreign key (actor_id) references users (id),
    constraint FK6cubi1liqrhpr7gwos6xu1ngm
        foreign key (role_id) references roles (id),
    constraint FKe9yfn8ry46vaw8gk2ll2bxyh0
        foreign key (status_id) references status (id)
);

create table if not exists routes
(
    estimated_cost             decimal(15, 2) null,
    estimated_distance_km      decimal(10, 2) null,
    estimated_duration_minutes int            null,
    completed_at               datetime(6)    null,
    created_at                 datetime(6)    null,
    created_by                 bigint         null,
    id                         bigint auto_increment
        primary key,
    updated_at                 datetime(6)    null,
    name                       varchar(255)   null,
    notes                      text           null,
    waypoints                  json           not null,
    constraint FKo7qer9ki3o4s9p797spq6qmrs
        foreign key (created_by) references users (id)
);

create table if not exists stores
(
    is_active  bit            null,
    latitude   decimal(10, 8) null,
    longitude  decimal(11, 8) null,
    created_at datetime(6)    null,
    created_by bigint         null,
    id         bigint auto_increment
        primary key,
    updated_at datetime(6)    null,
    phone      varchar(20)    not null,
    address    text           not null,
    email      varchar(255)   null,
    notes      text           null,
    store_name varchar(255)   not null,
    constraint FK3tmg8nrwxp3j154hicgymbo8e
        foreign key (created_by) references users (id)
);

create table if not exists orders
(
    benefit_per_order      decimal(15, 2) null,
    order_profit_per_order decimal(15, 2) null,
    status_id              smallint       null,
    total_amount           decimal(15, 2) null,
    created_at             datetime(6)    null,
    created_by             bigint         null,
    id                     bigint auto_increment
        primary key,
    store_id               bigint         null,
    updated_at             datetime(6)    null,
    description            text           null,
    notes                  text           null,
    constraint FKnoettwqr56yaai4i8nwxg4huo
        foreign key (status_id) references status (id),
    constraint FKnqkwhwveegs6ne9ra90y1gq0e
        foreign key (store_id) references stores (id),
    constraint FKtjwuphstqm46uffgc7l1r27a9
        foreign key (created_by) references users (id)
);

create table if not exists addresses
(
    latitude      decimal(10, 8)                        null,
    longitude     decimal(11, 8)                        null,
    created_at    datetime(6)                           null,
    id            bigint auto_increment
        primary key,
    order_id      bigint                                not null,
    updated_at    datetime(6)                           null,
    floor_number  varchar(10)                           null,
    contact_phone varchar(20)                           null,
    postal_code   varchar(20)                           null,
    city          varchar(100)                          null,
    country       varchar(100)                          null,
    region        varchar(100)                          null,
    state         varchar(100)                          null,
    address       varchar(500)                          not null,
    contact_email varchar(255)                          null,
    contact_name  varchar(255)                          null,
    address_type  enum ('DELIVERY', 'PICKUP', 'RETURN') not null,
    constraint FKsv7a6xjwuwlcwxbq98p0gqna
        foreign key (order_id) references orders (id)
);

create table if not exists delivery_proofs
(
    captured_at         datetime(6)                                                          null,
    created_at          datetime(6)                                                          null,
    id                  bigint auto_increment
        primary key,
    order_id            bigint                                                               null,
    uploaded_by         bigint                                                               null,
    file_name           varchar(255)                                                         null,
    file_path           varchar(255)                                                         null,
    notes               text                                                                 null,
    recipient_name      varchar(255)                                                         null,
    recipient_signature varchar(255)                                                         null,
    proof_type          enum ('AUDIO', 'DOCUMENT', 'PHOTO', 'RECEIPT', 'SIGNATURE', 'VIDEO') null,
    constraint FK4hed6fties4fpgjmcgm0ce7it
        foreign key (uploaded_by) references users (id),
    constraint FKmtwhwmhau28b7ioxf578o1adt
        foreign key (order_id) references orders (id)
);

create table if not exists payments
(
    amount         decimal(15, 2)                                          not null,
    status_id      smallint                                                null,
    created_at     datetime(6)                                             null,
    created_by     bigint                                                  null,
    id             bigint auto_increment
        primary key,
    order_id       bigint                                                  null,
    updated_at     datetime(6)                                             null,
    notes          text                                                    null,
    transaction_id varchar(255)                                            null,
    payment_method enum ('BANK_TRANSFER', 'CASH', 'CREDIT_CARD', 'STRIPE') null,
    constraint FK44957q7sogi6mtk6hs19kgycu
        foreign key (created_by) references users (id),
    constraint FK81gagumt0r8y3rmudcgpbk42l
        foreign key (order_id) references orders (id),
    constraint FKbo8xfx3js3yc1j11d3goimta5
        foreign key (status_id) references status (id)
);

create table if not exists vehicles
(
    capacity_volume_m3 decimal(10, 2) default 0.00    null,
    capacity_weight_kg decimal(10, 2) default 0.00    null,
    status_id          smallint                       not null,
    created_at         datetime(6)                    null,
    current_driver_id  bigint                         null,
    id                 bigint auto_increment
        primary key,
    updated_at         datetime(6)                    null,
    license_plate      varchar(20)                    not null,
    notes              text                           null,
    vehicle_type       varchar(50)    default 'TRUCK' not null,
    constraint UK9vovnbiegxevdhqfcwvp2g8pj
        unique (license_plate),
    constraint FK4yrgen35vwtcaohnh3f6ytlhf
        foreign key (current_driver_id) references users (id),
    constraint FKqn210wvgtyjs89dhgq0s24ch1
        foreign key (status_id) references status (id)
);

create table if not exists deliveries
(
    delivery_attempts      int                                      null,
    delivery_fee           decimal(38, 2)                           null,
    late_delivery_risk     int                                      not null,
    actual_delivery_time   datetime(6)                              null,
    created_at             datetime(6)                              null,
    driver_id              bigint                                   null,
    id                     bigint auto_increment
        primary key,
    order_date             datetime(6)                              not null,
    order_id               bigint                                   null,
    pickup_date            datetime(6)                              null,
    route_id               bigint                                   null,
    schedule_delivery_time datetime(6)                              null,
    updated_at             datetime(6)                              null,
    vehicle_id             bigint                                   not null,
    delivery_notes         text                                     null,
    service_type           enum ('EXPRESS', 'PRIORITY', 'STANDARD') null,
    transport_mode         enum ('AIR', 'RAIL', 'ROAD', 'SEA')      null,
    constraint FK7isx0rnbgqr1dcofd5putl6jw
        foreign key (order_id) references orders (id),
    constraint FKgjj47cndyarbxrqimqu8q16n8
        foreign key (vehicle_id) references vehicles (id),
    constraint FKm4ubh4uobntck32iawsw1mlvq
        foreign key (driver_id) references users (id),
    constraint FKsr9655vvbw7n7qjhlr2dnw447
        foreign key (route_id) references routes (id)
);

create table if not exists delivery_tracking
(
    latitude    decimal(10, 8) null,
    longitude   decimal(11, 8) null,
    status_id   smallint       null,
    created_at  datetime(6)    null,
    delivery_id bigint         not null,
    id          bigint auto_increment
        primary key,
    timestamp   datetime(6)    null,
    updated_at  datetime(6)    null,
    vehicle_id  bigint         null,
    location    varchar(255)   null,
    notes       text           null,
    constraint FK90u8fjlmxnktxvbrieqhopj1p
        foreign key (vehicle_id) references vehicles (id),
    constraint FKa7752nojalt7df2ssnia9er56
        foreign key (delivery_id) references deliveries (id),
    constraint FKd6knotam8v73fit5fy27ndx3i
        foreign key (status_id) references status (id)
);

create table if not exists warehouses
(
    capacity_m3 decimal(10, 2) not null,
    is_active   bit            not null,
    latitude    decimal(10, 8) null,
    longitude   decimal(11, 8) null,
    created_at  datetime(6)    null,
    created_by  bigint         null,
    id          bigint auto_increment
        primary key,
    updated_at  datetime(6)    null,
    address     text           not null,
    name        varchar(255)   not null,
    notes       text           null,
    constraint FK21mnq798od8r3ua4p16t539qi
        foreign key (created_by) references users (id)
);

create table if not exists products
(
    is_fragile     tinyint default 0           not null,
    stock_quantity int     default 0           not null,
    unit_price     decimal(15, 2)              not null,
    volume         decimal(10, 3)              null,
    weight         decimal(10, 3)              null,
    category_id    bigint                      not null,
    created_at     datetime(6)                 null,
    created_by     bigint                      null,
    id             bigint auto_increment
        primary key,
    updated_at     datetime(6)                 null,
    warehouse_id   bigint                      null,
    product_image  varchar(500)                null,
    description    text                        null,
    name           varchar(255)                not null,
    notes          text                        null,
    product_status enum ('ACTIVE', 'INACTIVE') not null,
    constraint FK71egr0nqa3sut2fdk34e7o9eq
        foreign key (warehouse_id) references warehouses (id),
    constraint FKl0lce8i162ldn9n01t2a6lcix
        foreign key (created_by) references users (id),
    constraint FKog2rp4qthbtt2lfyhfo32lsw9
        foreign key (category_id) references categories (id)
);

create table if not exists order_items
(
    quantity     int            not null,
    shipping_fee decimal(38, 2) null,
    unit_price   decimal(38, 2) null,
    created_at   datetime(6)    null,
    id           bigint auto_increment
        primary key,
    order_id     bigint         null,
    product_id   bigint         null,
    updated_at   datetime(6)    null,
    notes        text           null,
    constraint FKbioxgbv59vetrxe0ejfubep1w
        foreign key (order_id) references orders (id),
    constraint FKocimc7dtr037rh4ls4l95nlfi
        foreign key (product_id) references products (id)
);

create table if not exists warehouse_transactions
(
    quantity         int                                          not null,
    status_id        smallint                                     not null,
    unit_cost        decimal(15, 2)                               not null,
    created_at       datetime(6)                                  null,
    created_by       bigint                                       null,
    id               bigint auto_increment
        primary key,
    order_id         bigint                                       null,
    product_id       bigint                                       not null,
    transaction_date datetime(6)                                  null,
    warehouse_id     bigint                                       not null,
    notes            text                                         null,
    transaction_type enum ('ADJUSTMENT', 'IN', 'OUT', 'TRANSFER') not null,
    constraint FK1k616ccc707y4tev1wutl5js3
        foreign key (warehouse_id) references warehouses (id),
    constraint FK6ng5771b627624vkpb4gpnt8v
        foreign key (order_id) references orders (id),
    constraint FKii7cqst2f5v46m9vw89bsoagb
        foreign key (created_by) references users (id),
    constraint FKm7x929mp5cskfp9crl6vwnbcu
        foreign key (product_id) references products (id),
    constraint FKtit1cp176fxb7eb68i4n20fwy
        foreign key (status_id) references status (id)
);
