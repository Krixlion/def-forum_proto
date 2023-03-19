#! /bin/sh.
ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")"
ROOT_DIR="$(realpath "${ROOT_DIR}")"

for SERVICE_DIR in $(ls -d */); do
    SERVICE_DIR=${SERVICE_DIR%'/'}
    
    PB_PATH="$(mkdir -p ${ROOT_DIR}/${SERVICE_DIR}/${SERVICE_DIR}_pb ${ROOT_DIR}/${SERVICE_DIR}/docs && cd $ROOT_DIR/${SERVICE_DIR}/${SERVICE_DIR}_pb && pwd)"
    PROTO_PATH="$(ls ${SERVICE_DIR} | grep .proto)"

    protoc --go_out=paths=source_relative:$PB_PATH \
        --doc_out=$ROOT_DIR/${SERVICE_DIR}/docs \
        --doc_opt=markdown,api.md \
        --go-grpc_out=paths=source_relative:$PB_PATH \
        -I $ROOT_DIR/$SERVICE_DIR/ ${PROTO_PATH}
    
    protoc-go-inject-tag -input="$PB_PATH/*.pb.go"
done