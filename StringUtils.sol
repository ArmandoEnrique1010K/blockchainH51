// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library StringUtils {
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
}
