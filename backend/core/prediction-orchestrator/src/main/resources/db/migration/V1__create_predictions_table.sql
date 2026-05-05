CREATE TABLE predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id VARCHAR(255) NOT NULL,
    model_id VARCHAR(255) NOT NULL,
    model_name VARCHAR(255)NOT NULL,
    status VARCHAR(255)NOT NULL,
    input_data JSONB NOT NULL,
    output_data JSONB,
    created_at TIMESTAMP NOT NULL, 
    completed_at TIMESTAMP
);