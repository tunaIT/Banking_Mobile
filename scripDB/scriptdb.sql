-- Tạo chuỗi cho bảng users
CREATE SEQUENCE users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Tạo chuỗi cho bảng transition
CREATE SEQUENCE transition_transition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Tạo chuỗi cho bảng payment
CREATE SEQUENCE payment_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE users (
    user_id integer DEFAULT nextval('users_user_id_seq'::regclass),              -- ID của người dùng, tự tăng
    created_at timestamp(6),  -- Thời gian tạo bản ghi
    email VARCHAR(255),       -- Email của người dùng, bắt buộc và duy nhất
    username VARCHAR(100),    -- Tên người dùng, bắt buộc và duy nhất
    hashed_password varchar(255),            -- Mật khẩu đã mã hóa
    updated_at timestamp(6),  -- Thời gian cập nhật cuối cùng
    balance double precision DEFAULT 0.0,       -- Số dư, kiểu số thực với 2 chữ số thập phân, mặc định là 0.0
    card_number varchar,           -- Số thẻ ngân hàng, duy nhất
    bank varchar                         -- Tên ngân hàng
);

CREATE TABLE transition (
    transition_id double precision DEFAULT nextval('transition_transition_id_seq'::regclass) PRIMARY KEY,          
    amount double precision NOT NULL,           
    created_at timestamp(6),
    fee double precision,            
    from_user varchar(255),              
    to_user varchar(255)                     
);

CREATE TABLE payment (
    payment_id integer DEFAULT nextval('payment_payment_id_seq'::regclass) PRIMARY KEY,             -- Mã thanh toán, tự động tăng, khóa chính
    amount double precision NOT NULL,            -- Số tiền thanh toán, 2 chữ số thập phân
    category VARCHAR(100),            -- Loại thanh toán (ví dụ: "utilities", "shopping")
    created_at TIMESTAMP,  -- Thời gian tạo thanh toán
    for_user varchar(255),                     -- ID người nhận thanh toán (tham chiếu đến users.user_id)
    status VARCHAR(50)               -- Trạng thái thanh toán (ví dụ: "pending", "completed")
);

CREATE TABLE bill (
    code VARCHAR(100) PRIMARY KEY,             -- Mã giao dịch (duy nhất), khóa chính
    address VARCHAR(255) NOT NULL,             -- Địa chỉ người dùng
    amount double precision NOT NULL,            -- Số tiền giao dịch, 2 chữ số thập phân
    category VARCHAR(100),                     -- Loại giao dịch (ví dụ: "transfer", "payment")
    fee double precision DEFAULT 0.0,            -- Phí giao dịch, mặc định là 0.0
    from_date TIMESTAMP NOT NULL,              -- Ngày bắt đầu giao dịch
    phone_number VARCHAR(20),                  -- Số điện thoại người dùng
    tax double precision DEFAULT 0.0,            -- Thuế áp dụng, mặc định là 0.0
    to_date TIMESTAMP,                         -- Ngày kết thúc giao dịch (có thể null)
    user_name VARCHAR(100) NOT NULL            -- Tên người dùng thực hiện giao dịch
);
