// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./DataManagement.sol";
import "./TokenIssuance.sol";
import "./StringUtils.sol";

contract CopyrightMusic is ERC20, DataManagement, TokenIssuance  {

    using StringUtils for string;

    address public owner;
    uint256 public lastDataId;
function subirDatos(
    string memory _titulo_cancion,
    string memory _album,
    EntityGenero _genre,
    string memory _idioma,
    string memory _artista_principal,
    string[] memory _lista_artistas_invitados,
    uint8 _day,
    uint8 _month,
    uint16 _year,
    string memory _isrc
) public onlyOwner {
    // Incrementa el ID para la nueva canción
    lastDataId++;

    // Almacena los datos en la estructura correspondiente
    datosSubidos[lastDataId] = Datos({
        id: lastDataId,
        titulo_cancion: _titulo_cancion,
        album: _album,
        genre: _genre,
        idioma: _idioma,
        artista_principal: _artista_principal,
        lista_artistas_invitados: _lista_artistas_invitados,
        day: _day,
        month: _month,
        year: _year,
        isrc: _isrc,
        fechaYHoraActual: block.timestamp
    });

    // Emite el evento indicando que se han subido datos de una canción
    emit DatosSubidos(
        lastDataId,
        _titulo_cancion,
        _album,
        _genre,
        _idioma,
        _artista_principal,
        _lista_artistas_invitados,
        _day,
        _month,
        _year,
        _isrc,
        block.timestamp
    );

    // Otorga una recompensa de tokens al que llama la función
    uint256 recompensa = 5; // Cantidad de tokens como recompensa
    _mint(msg.sender, recompensa);

    // Emite el evento indicando que se ha otorgado una recompensa de tokens
    emit RecompensaTokens(msg.sender, recompensa);
}

    // Constructor del contrato
    constructor() payable ERC20("Copyright Token", "CTK") {
        owner = msg.sender;
        lastDataId = 0;
        _mint(msg.sender, 1000000 * 10**decimals());
    }

    // Modificador para permitir solo al propietario realizar ciertas operaciones
    modifier onlyOwner() {
        require(msg.sender == owner, "Error");
        _;
    }

}