div#cssmenu {
    padding-bottom: 0;
}
  
#cssmenu ul#ui {
    box-shadow: none;
    border-top-left-radius: 7px;
    border-top-right-radius: 7px;
    border-style: solid;
    border-width: 0 0 3px;
    border-color: #1797c0;
    padding-top: 1px;
}

#cssmenu ul#ui li {
    margin: 0;
    padding: 0 10px;
}

ul#ui li a {
    font-size: 13px;
    font-family: Arial, Helvetica, sans-serif;
    color: #333435;
    padding: 0 10px;
}

ul#ui li a:hover {
    color: #1468b6;
}

.apexp .secondaryPalette.bPageBlock {
    border: none;
}

body div.apexp .bPageBlock.apexDefaultPageBlock .pbHeader {
    border: none;
}

.editPage .bPageBlock .pbHeader {
    margin-bottom: 10px;
}

div.apexp .bPageBlock.apexDefaultPageBlock .pbHeader>table {
    padding: 0;
    border-bottom: none;
}

.apexp .bPageBlock:not(.bEditBlock):not(.bDetailBlock) .pbHeader>table>tbody>tr>td {
    padding: 5px 5px 15px;
}

.apexp>.bPageBlock:not(.bDetailBlock) .pbHeader>table>tbody>tr>td.pbTitle {
    display: none;
}

/* remove this style after removing the referenced elements */
.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubheader,
#tblContainer_length,
.apexp .pbBottomButtons,
.editPage .detailList .pbHeader,
#frm-hover {
    display: none;
}

.apexp .editPage .pbBottomButtons,
.apexp .bDetailBlock .pbBottomButtons {
	display: block;
}

.apexp {
	border: 1px solid #e0e3e5;
}

.dataCol .apexp {
	border: none;
}

.apexp>.bPageBlock,
.apexp>.editPage>.bPageBlock {
	margin-bottom: 0;
}

div.apexp .bPageBlock.apexDefaultPageBlock .pbBody {
    margin: 0;
}

.apexp .bPageBlock .detailList .data2Col {
    padding: 0;
}

.detailList .data2Col.last:not(.first) {
	padding: 5px 0;
}

.detailList .data2Col.first {
    border: none;
}

/* remove this style after removing the referenced elements -
   page size selector and search box should be moved first */
.dataTables_wrapper .fg-toolbar:first-child {
    display: none;
}

.bPageBlock .detailList .dataTables_wrapper tr th {
    background-color: #f2f3f3;
    border-color: #e0e3e5;
    border-bottom-style: solid;
    color: #222;
    /* the !important is required to override the dynamic width */
    width: 1px !important;
}

.bPageBlock .detailList .dataTables_wrapper tr th:first-child,
.editPage .bPageBlock .detailList .dataTables_wrapper tr th:nth-of-type(2) {
    border-left-width: 0;
}

.bPageBlock .detailList .dataTables_wrapper tr th:last-child,
.bPageBlock .detailList .dataTables_wrapper tr th:nth-last-of-type(2) {
    border-right-width: 0;
}

.bPageBlock .detailList .dataTables_wrapper tr th:hover {
    background-color: #e6eaea;
    color: #015ba7;
    cursor: pointer;
}

.editPage table.detailList {
    border: none;
}

.editPage .dataTables_wrapper {
    border: 1px solid #e0e3e5;
    border-top: none;
}

.dataTables_wrapper tbody tr {
    font-size: 12px;
}

.dataTables_wrapper tbody tr {
    background-color: #fff;
    border-bottom: 1px solid #ededed;
}

.dataTables_wrapper tbody tr:last-child {
    border-bottom: none;
}

.dataTables_wrapper tbody tr:hover {
    background-color: #e3f3ff;
}

.dataTables_wrapper tbody tr.selected {
    background-color: #e3f3ff;
}

.dataTables_wrapper tbody tr td,
.dataTables_wrapper tbody tr td[class*='sorting'] {
    background-color: inherit;
    white-space: nowrap;
}

.dataTables_wrapper tbody tr:last-child td {
    border-color: #e0e3e5;
}

.dataTables_wrapper div.DataTables_sort_wrapper {
    font-weight: bold;
    color: inherit;
    font-size: 11px;
}

.dataTables_wrapper .fg-toolbar:last-child {
    background-color: #f2f3f3;
    border-color: #e0e3e5;
    border-width: 1px 0 0;
    border-radius: 0;
}

.editPage .pbBody .pbSubsection {
    margin: 0;
}

.dataTables_wrapper div.dataTables_info {
    width: 1px;
    white-space: nowrap;
}

.dataTables_paginate>a {
    display: inline-block;
}

.editPage .bPageBlock .detailList .dataCol {
    width: 50%;
}

a.smLink {
    font-weight: bold;
}

a.smLink:after {
    content: "»";
    margin-left: 5px;
    display: inline-block;
    text-decoration: none;
}

iframe#preview {
    border: 1px solid #e0e3e5 !important;
    background-color: #fff;
}

.editPage .bPageBlock.bEditBlock .detailList .dataCol {
    padding: 0;
}

.editPage .bPageBlock.bEditBlock .detailList .dataCol:first-child {
    padding-right: 10px;
}

.editPage .pbSubsection .detailList .pbBody p {
	font-size: 13px;
    border: 1px solid #e0e3e5;
    margin-top: 0;
    padding: 20px;
    font-style: normal;
    color: #de7e35;
}

.editPage #email-title {
    position: static;
    display: inline-block;
}

/* following style will be obsolete after adding/switching to field labels */
.editPage #email-title:first-child,
.editPage .pbSubsection .detailList .apexp .pbBody>b {
	display: inline-block;
    font-weight: bold;
    height: 24px;
	color: #4a4a56;
	font-size: 11px;
}

.editPage .pbSubsection .detailList .apexp .pbBody>label {
	font-size: 11px;
    font-weight: bold;
    color: #4a4a56;
    width: 95px;
    display: inline-block;
    height: 24px;
}

.editPage .pbSubsection .detailList .apexp .pbBody>input[type=text] {
    margin-left: 4px;
}

.editPage .pbSubsection .detailList .apexp .pbBody>textarea {
    width: 99% !important;
    margin-bottom: 10px;
}

.detailList .data2Col span>table {
    width: 100%;
    border-spacing: 0;
}

.detailList td.MainHeading {
    font-weight: bold;
    font-size: 13px;
    height: 15px;
    padding: 4px 16px;
    background-color: #e0e3e5;
}

.bPageBlock .detailList .data2Col span>table td {
    vertical-align: middle;
}

.bPageBlock .detailList td.LeftColumn {
    line-height: 30px;
    font-weight: bold;
    font-size: 11px;
    color: #4a4a56;
    width: 18%;
    text-align: right;
    vertical-align: middle;
    padding: 3px 10px 3px 2px;
}

.detailList table.leftIndented td input.btn {
    border-radius: 0;
    margin: 0;
    border-width: 1px 0 1px 1px;
    padding: 4px 8px
}

.detailList table.leftIndented td input.btn:nth-of-type(1) {
    border-radius: 3px 0 0 3px;
}

.detailList table.leftIndented td input.btn:nth-last-of-type(1) {
    border-radius: 0 3px 3px 0;
    border-right-width: 1px;
}

.detailList .data2Col span>table table b {
	font-size: 11px;
    color: #4a4a56;
}

#DataTableDiv>#DataTable_wrapper {
    border: 1px solid #e0e3e5;
    margin: 0 5px 10px 0;
}

#DataTableDiv .dataTable {
    border: none;
}

#DataTableDiv .dataTable th {
    border-top: none;
}

#DataTableDiv .dataTable tbody td {
    border: none;
}

.apexp .bDetailBlock.bPageBlock {
    margin-bottom: 0;
    background-color: #f8f8f8;
}

.apexp .bPageBlock.bDetailBlock .pbHeader {
    border-bottom: 1px solid #fff;
}

.apexp .bPageBlock.bDetailBlock .pbHeader>table:nth-of-type(1) {
    border-bottom: 1px solid #e0e3e5;
}

 
.apexp .bPageBlock.bDetailBlock .detailList td {
	vertical-align: middle;
    line-height: 30px;
}

