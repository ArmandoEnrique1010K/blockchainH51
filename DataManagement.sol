// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataManagement {
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
