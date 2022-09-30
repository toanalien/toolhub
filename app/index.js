(function() {

    var c = tronWeb.utils.crypto;
    var code = tronWeb.utils.code;

    const trongrid = 'https://nile.trongrid.io';
    const trongridRpc = "https://nile.trongrid.io/jsonrpc";
    
    const api = axios.create({
        baseURL: trongrid,
        timeout: 10000,
    });
    async function query() {
        console.log("tronweb: ", window.tronWeb);
  
        const tronPrivatekey = "eda1f4bcb5e6c80cef3d520e5d27cf1195c3f1b829b63dd44b75f2c9d4992ce9";

        var ownerAddress = 'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj';
        var toAddress = 'TKaUvCJBEEbJX35ZJzuULnvYL8bsXS9aB6';

        var {data: block} = await api.post("/wallet/getblock", {detail: false});

        console.log('block: ', block);

        // 获取 transaction
        var {data: transaction} = await api.post("/wallet/createtransaction",
        {
            "to_address": tronWeb.address.toHex(toAddress),
            "owner_address": tronWeb.address.toHex(ownerAddress),
            "amount": 100000,
            'extra_data': tronWeb.toHex('test').replace("0x", "")
        });

        console.log("transaction: ", transaction);

        // transaction.raw_data.data = '4736574';

        var { signature } = c.signTransaction(tronPrivatekey, {txID: transaction.txID});
        

        console.log("signature", signature);

        return {transaction, signature};
    }

    async function send(transaction, signature) {
        var {data: send} = await api.post("/wallet/broadcasttransaction", {
            raw_data: JSON.stringify(transaction.raw_data),
            signature: signature,
            txID: transaction.txID
        });

        console.log("send", send, );

        if(send.code) {
            console.log("message: ", tronWeb.toUtf8(send.message));
        }
    }

    async function verify() {
        // conert hex string to byte array
        var byteArray = tronWeb.utils.code.hexStr2byteArray('e6725b4da23a84b0a2bea1df8609965d25db0318c20d79c6c69197a08cbf3889')
        // keccak256 computing, then remove "0x" 
        var strHash= tronWeb.sha3(byteArray).replace(/^0x/, '');
        // sign 
        var signedStr = await tronWeb.trx.sign(strHash);
        // signedStr = 'aa1501ee9ba380c72a10435bc420f68402b70d5a9d243dff926c18072a091928682016fdd0dda0ad74efc4ccbfc30bb0817905cd9091089a68a73ddc9e8311b900';
        signedStr = 'aa1501ee9ba380c72a10435bc420f68402b70d5a9d243dff926c18072a09192897dfe9022f225f528b103b33403cf44e3935d7191eb797a1572b20b031b32f8800';
        var tail = signedStr.substring(128, 130);
        if(tail == '01')
        {
            signedStr = signedStr.substring(0,128)+'1c';
        }
        
        else if(tail == '00')
        {
            signedStr = signedStr.substring(0,128)+'1b';
        }

        // verify the signature
        var res = await tronWeb.trx.verifyMessage(strHash, signedStr,'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj')
        console.log(res);
    }

    async function verifyByResponse(id, signature) {
        // convert to hex format and remove the beginning "0x"
        var hexStrWithout0x = tronWeb.toHex(id).replace(/^0x/, '');

        var byteArray = tronWeb.utils.code.hexStr2byteArray(hexStrWithout0x)
        // keccak256 computing, then remove "0x" 
        var strHash= tronWeb.sha3(byteArray).replace(/^0x/, '');

        var signedStr = signature[0];
        var tail = signedStr.substring(128, 130);
        if(tail == '01')
        {
            signedStr = signedStr.substring(0,128)+'1c';
        }
        
        else if(tail == '00')
        {
            signedStr = signedStr.substring(0,128)+'1b';
        }

        var res = await tronWeb.trx.verifyMessage(strHash, signedStr,'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj')
        console.log(res);
    }

    window.onload = async function () {
        const {transaction, signature } = await query();
        await send(transaction, signature);

        // window.verify = function() {
        //     verifyByResponse(transaction.txID, signature);
        // }
    };
    
})()
// var a = {
//   visible: false,
//   txID: "c66875cef2a8c356330f8bc85556cb4d8450933602ca336e94ef14c404a97aed",
//   raw_data: {
//     data: "74657374",
//     contract: [
//       {
//         parameter: {
//           value: {
//             amount: 100000,
//             owner_address: "41f35ed99ea8821fcedb311bb75c6437cac2df3ee7",
//             to_address: "416964fa12b2a9f542e4eaf382416862824c1f7280",
//           },
//           type_url: "type.googleapis.com/protocol.TransferContract",
//         },
//         type: "TransferContract",
//       },
//     ],
//     ref_block_bytes: "0f35",
//     ref_block_hash: "7aac6c98714232d2",
//     expiration: 1664516754000,
//     timestamp: 1664516696096,
//   },
//   raw_data_hex:
//     "0a020f3522087aac6c98714232d240d094b8e7b8305204746573745a67080112630a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412320a1541f35ed99ea8821fcedb311bb75c6437cac2df3ee71215416964fa12b2a9f542e4eaf382416862824c1f728018a08d0670a0d0b4e7b830",
// };

// var b = {
//   result: true,
//   txid: "c66875cef2a8c356330f8bc85556cb4d8450933602ca336e94ef14c404a97aed",
// };


// ['ef0b48b4bf720bec48fc2f1d9350e0b779ade1fbb9e0e7e6df…5caf8af491be075bb8769196edf8914c366e57de0ffd5b601']