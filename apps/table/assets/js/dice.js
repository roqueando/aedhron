import Konva from 'konva';

export function extractDataDice(Element) {
    const dice = Element.getAttribute('data-dice')
    const result = Element.getAttribute('data-result')
    return {
        dice,
        result
    }
}

