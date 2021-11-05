import React from 'react';
import {cn} from '@bem-react/classname';

export interface ImageProps {
    className?: string;
}

const STUB = 'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PjxzdmcgaWQ9ImNhdGNpcmNsZSIgc3R5bGU9Im' +
    'VuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMzAwIDMwMDsiIHZlcnNpb249IjEuMSIgdmlld0JveD0iMCAwIDMwMCAzMDAiIHhtbDpzc' +
    'GFjZT0icHJlc2VydmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3' +
    'JnLzE5OTkveGxpbmsiPjxnPjxjaXJjbGUgY3g9IjE1NCIgY3k9IjE1NCIgcj0iMTIwIiBzdHlsZT0iZmlsbC1ydWxlOmV2ZW5vZGQ7Y2' +
    'xpcC1ydWxlOmV2ZW5vZGQ7ZmlsbDpub25lO3N0cm9rZTojMDAwMDAwO3N0cm9rZS13aWR0aDo4O3N0cm9rZS1saW5lY2FwOnJvdW5kO3N0' +
    'cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDoxMDsiLz48cGF0aCBkPSIgICBNMTY0LjQ1NywxNzYuODU3QzE4MS40Njg' +
    'sMTczLjE3NSwxOTQsMTYwLjc3NCwxOTQsMTQ2YzAtNS4yMjctMS41OTgtMTAuMTQ2LTQuMzc2LTE0LjUwM0MxOTEuNzA2LDExMy4xODMsMTg' +
    'zLjcxMiw5NCwxODMuNzEyLDk0ICAgYy03LjUxOCw0Ljg1Ni0xNC4zODgsMTcuMTE0LTE2Ljc5NSwyMS43MzhDMTYyLjg2LDExNC42MywxNTgu' +
    'NTI2LDExNCwxNTQsMTE0cy04Ljg2LDAuNjMtMTIuOTE3LDEuNzM4ICAgYy0yLjQwNy00LjYyNC05LjI3Ni0xNi44ODItMTYuNzk0LTIxLjczOGM' +
    'wLDAtNy45OTUsMTkuMTgzLTUuOTEzLDM3LjQ5N0MxMTUuNTk4LDEzNS44NTQsMTE0LDE0MC43NzMsMTE0LDE0NiAgIGMwLDE0Ljc3NCwxMi41MzI' +
    'sMjcuMTc1LDI5LjU0MywzMC44NTdDMTI2LjUzMiwxODYuMDY0LDExNCwyMTcuMDY1LDExNCwyNTRjMCw0LjU1NCwwLjE5LDkuMDIsMC41NTYsMTMu' +
    'MzY3ICAgQzEyNi45MSwyNzEuNjY0LDE0MC4xODIsMjc0LDE1NCwyNzRzMjcuMDktMi4zMzYsMzkuNDQ0LTYuNjMzQzE5My44MSwyNjMuMDIsMTk0LD' +
    'I1OC41NTQsMTk0LDI1NCAgIEMxOTQsMjE3LjA2NSwxODEuNDY4LDE4Ni4wNjQsMTY0LjQ1NywxNzYuODU3eiIgc3R5bGU9ImZpbGwtcnVsZTpldmVu' +
    'b2RkO2NsaXAtcnVsZTpldmVub2RkO2ZpbGw6bm9uZTtzdHJva2U6IzAwMDAwMDtzdHJva2Utd2lkdGg6ODtzdHJva2UtbGluZWNhcDpyb3VuZDtzdHJv' +
    'a2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6MTA7Ii8+PC9nPjxnLz48Zy8+PGcvPjxnLz48Zy8+PGcvPjxnLz48Zy8+PGcvPjxnLz4' +
    '8Zy8+PGcvPjxnLz48Zy8+PGcvPjwvc3ZnPg==';

const bem = cn('Image');

export const Image: React.FC<ImageProps> = ({className}) => {
    return <img className={bem(null, [className])} src={STUB}/>;
}
