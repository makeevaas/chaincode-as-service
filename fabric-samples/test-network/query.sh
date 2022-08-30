#!/bin/bash
#
CC_NAME="$1"

export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
sleep 2

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
sleep 2

echo "# ---------------------------------------------------------------------------"
echo "#                                                                            "
echo "# Invoking chaincode : InitLedger"
echo "#                                                                            "
echo "# ---------------------------------------------------------------------------"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n $CC_NAME --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'
sleep 3

echo "# ---------------------------------------------------------------------------"
echo "#                                                                            "
echo "# Invoking chaincode : GetAllAssets"
echo "#                                                                            "
echo "# ---------------------------------------------------------------------------"
peer chaincode query -C mychannel -n $CC_NAME -c '{"Args":["GetAllAssets"]}'
sleep 3

echo "# ---------------------------------------------------------------------------"
echo "#                                                                            "
echo "# Invoking chaincode : CreateAsset"
echo "#                                                                            "
echo "# ---------------------------------------------------------------------------"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n $CC_NAME --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"CreateAsset","Args":["testAsset","Green","1","2","3"]}'
sleep 3

echo "# ---------------------------------------------------------------------------"
echo "#                                                                            "
echo "# Invoking chaincode : GetAllAssets"
echo "#                                                                            "
echo "# ---------------------------------------------------------------------------"
peer chaincode query -C mychannel -n $CC_NAME -c '{"Args":["GetAllAssets"]}'
sleep 3

echo "# ---------------------------------------------------------------------------"
echo "#                                                                            "
echo "# Invoking chaincode : ReadAsset"
echo "#                                                                            "
echo "# ---------------------------------------------------------------------------"
peer chaincode query -C mychannel -n $CC_NAME -c '{"Args":["ReadAsset","testAsset"]}'
sleep 3