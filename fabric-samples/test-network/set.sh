#!/bin/bash
#
CC_ID_B="$1"
CC_ID_P="$2"

export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
sleep 2

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
sleep 2

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem --channelID mychannel --name basic --version 1.0 --package-id $CC_ID_B --sequence 1
sleep 3

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem --channelID mychannel --name payment --version 1.0 --package-id $CC_ID_P --sequence 1
sleep 3

peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name basic --version 1.0 --sequence 1 --output json
sleep 2

peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name payment --version 1.0 --sequence 1 --output json
sleep 2

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
sleep 2

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem --channelID mychannel --name basic --version 1.0 --package-id $CC_ID_B --sequence 1
sleep 3

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem --channelID mychannel --name payment --version 1.0 --package-id $CC_ID_P --sequence 1
sleep 3

peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name basic --version 1.0 --sequence 1 --output json
sleep 2

peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name payment --version 1.0 --sequence 1 --output json
sleep 2

peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem --channelID mychannel --name basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem --version 1.0 --sequence 1
sleep 3

peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem --channelID mychannel --name payment --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem --version 1.0 --sequence 1
sleep 3

peer lifecycle chaincode querycommitted --channelID mychannel --name basic
sleep 2

peer lifecycle chaincode querycommitted --channelID mychannel --name payment
sleep 2

#echo "# ---------------------------------------------------------------------------"
#echo "#                                                                            "
#echo "# Starting the Chaincode-as-a-Service docker containers                      "
#echo "#                                                                            "
#echo "# ---------------------------------------------------------------------------"
#docker run --rm -d --name peer0org1_cc --network fabric_test -e CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 -e CHAINCODE_ID=$CC_ID -e CORE_CHAINCODE_ID_NAME=$CC_ID cc_image:0.1
#docker run --rm -d --name peer0org2_cc --network fabric_test -e CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 -e CHAINCODE_ID=$CC_ID -e CORE_CHAINCODE_ID_NAME=$CC_ID cc_image:0.1
#
echo "# ---------------------------------------------------------------------------"
echo "#                                                                            "
echo "# Starting the Chaincode-as-a-Service podman containers                      "
echo "#                                                                            "
echo "# ---------------------------------------------------------------------------"
podman run --rm -d --name peer0org1_cc --network fabric_test -e CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 -e CHAINCODE_ID=$CC_ID_B -e CORE_CHAINCODE_ID_NAME=$CC_ID_B cc_image:0.1
podman run --rm -d --name peer0org2_cc --network fabric_test -e CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 -e CHAINCODE_ID=$CC_ID_B -e CORE_CHAINCODE_ID_NAME=$CC_ID_B cc_image:0.1
podman run --rm -d --name peer0org1_cc2 --network fabric_test -e CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 -e CHAINCODE_ID=$CC_ID_P -e CORE_CHAINCODE_ID_NAME=$CC_ID_P cc_image:0.1
podman run --rm -d --name peer0org2_cc2 --network fabric_test -e CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 -e CHAINCODE_ID=$CC_ID_P -e CORE_CHAINCODE_ID_NAME=$CC_ID_P cc_image:0.1