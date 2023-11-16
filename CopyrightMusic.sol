// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CopyrightMusic is ERC20 {
    address public owner;
    uint256 public lastDataId;

    // Enumerador para los géneros musicales
    enum EntityGenero {
        Pop, // 0
        Rock, // 1
        HipHop, // 2
        Electronica, // 3
        Jazz, // 4
        Otro // 5
    }

    // Estructura para almacenar los datos de una canción
    struct Datos {
        uint256 id;
        string titulo_cancion;
        string album;
        EntityGenero genre; // ID del Genero musical
        string idioma;
        // AUTORES
        string artista_principal;
        string[] lista_artistas_invitados;
        // string compositor;
        // string editora;
        // string [] lista_productores;
        // FECHA DE SUBIDA
        uint8 day;
        uint8 month;
        uint16 year;
        // SEGURIDAD
        string isrc;
        uint256 fechaYHoraActual; // https://www.cdmon.com/es/apps/conversor-timestamp <--- DESENCRIPTAR LA FECHA Y HORA
    }

    // Mapeo para almacenar los datos de cada canción por su ID
    mapping(uint256 => Datos) public datosSubidos;

    // Evento para notificar cuando se suben datos de una canción
    event DatosSubidos(
        uint256 indexed id,
        string titulo_cancion,
        string album,
        EntityGenero genre,
        string idioma,
        string artista_principal,
        string[] lista_artistas_invitados,
        uint8 day,
        uint8 month,
        uint16 year,
        string isrc,
        uint256 fechaYHoraActual
    );

    // Evento para notificar cuando se otorgan recompensas de tokens
    event RecompensaTokens(address indexed beneficiario, uint256 cantidad);

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

    // Función para subir datos de una canción junto con la fecha y hora actual
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

    // Función para dividir una cadena en un array de cadenas usando un delimitador
    function splitString(string memory _input, string memory _delimiter)
        internal
        pure
        returns (string[] memory)
    {
        bytes memory inputBytes = bytes(_input);
        bytes memory delimiterBytes = bytes(_delimiter);
        uint256 itemCount = 1;

        for (uint256 i = 0; i < inputBytes.length; i++) {
            if (inputBytes[i] == bytes1(delimiterBytes[0])) {
                itemCount++;
            }
        }

        string[] memory items = new string[](itemCount);
        uint256 currentIndex = 0;
        uint256 currentStart = 0;

        for (uint256 i = 0; i < inputBytes.length; i++) {
            if (inputBytes[i] == bytes1(delimiterBytes[0])) {
                items[currentIndex] = substring(_input, currentStart, i);
                currentStart = i + 1;
                currentIndex++;
            }
        }

        items[currentIndex] = substring(
            _input,
            currentStart,
            inputBytes.length
        );

        return items;
    }

    // Función para obtener una subcadena de una cadena
    function substring(
        string memory _str,
        uint256 _start,
        uint256 _end
    ) internal pure returns (string memory) {
        bytes memory strBytes = bytes(_str);
        bytes memory result = new bytes(_end - _start);
        for (uint256 i = _start; i < _end; i++) {
            result[i - _start] = strBytes[i];
        }
        return string(result);
    }

    // Función para obtener los datos de una canción por su ID
    function obtenerDatosSubidos(uint256 id)
        public
        view
        returns (
            string memory,
            string memory,
            EntityGenero,
            string memory,
            string memory,
            string[] memory,
            uint8,
            uint8,
            uint16,
            string memory,
            uint256
        )
    {
        // Obtiene los datos de la canción correspondiente al ID
        Datos storage datos = datosSubidos[id];
        return (

            // Retorna los datos de la canción
            datos.titulo_cancion,
            datos.album,
            datos.genre,
            datos.idioma,
            datos.artista_principal,
            datos.lista_artistas_invitados,
            datos.day,
            datos.month,
            datos.year,
            datos.isrc,
            datos.fechaYHoraActual
        );
    }
}
