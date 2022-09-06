/ SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketPlaceNFT is Ownable {
   
    ERC721 public nftContrato;//referência do contrato do NFT
    ERC20 public usdtContrato;//referência do contrato do USDT

    uint256 public precoNft; //preço do NFT
    uint256 public qtNftVendidos; //quantidade de tokens vendidos

    address payable public vedendor; //endereco da carteira do vedendor

    //Evento que é sempre disparado quando uma compra de token é realizada
    event Venda(address _comprador, uint256 _nftId);

    //método construtor
    constructor(address _nftContrato, uint256 _precoNft) {
                
        require(_nftContrato != address(0) && _nftContrato != address(this));
        require(_precoNft > 0); 

        nftContrato = ERC721(_nftContrato);
        //Endereco do contrato do USDT implantado na rede Testnet BSC
        usdtContrato = ERC20(0x337610d27c682E347C9cD60BD4b3b107C9d34dDd);
        precoNft = _precoNft;        
    }

    function comprarNft(uint _nftId) public payable {       

        vedendor = payable(nftContrato.ownerOf(_nftId));

        require(
            msg.value >= precoNft,
            "O preco do NFT nao corresponde ao valor pago"
        );
      
        require(
            usdtContrato.transferFrom(msg.sender, vedendor, 1),
            "O pagamento nao foi realizado"
        );
        
        nftContrato.safeTransferFrom(vedendor, msg.sender, _nftId);         
        qtNftVendidos++;
        emit Venda(msg.sender, _nftId);
    }

    function alterarPreco(uint256 _novoPreco) public onlyOwner{
        require(_novoPreco > 0);
        precoNft = _novoPreco;
    }
    
}
