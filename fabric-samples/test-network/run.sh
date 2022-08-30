#!/bin/bash
#

export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
sleep 2

cp ../../chaincode-external/pkg/basic.tar.gz .
cp ../../chaincode-external/pkg1/payment.tar.gz .
sleep 2

peer lifecycle chaincode package basic.tar.gz --path ./test-c./po
sleep 5

peer lifecycle chaincode package payment.tar.gz --path ./test-c./po
sleep 5

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
sleep 2

peer lifecycle chaincode install basic.tar.gz
sleep 3

peer lifecycle chaincode install payment.tar.gz
sleep 3

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
sleep 2

peer lifecycle chaincode install basic.tar.gz
sleep 3

peer lifecycle chaincode install payment.tar.gz
sleep 3

peer lifecycle chaincode queryinstalled
sleep 5