<?php
$rows = "";
$cols = "";
function createTable()
{

    // đọc các hệ số từ FORM
    if (isset($_GET['rows'])) {
        $rows = $_GET['rows'];
    }
    if (isset($_GET['cols'])) {
        $cols = $_GET['cols'];
    }

    $theader = "<table border='1' width='500'>\n";
    $tbody = "";

    for ($i = 0; $i < $rows; $i++) {
        $tbody .= "<tr>";
        for ($j = 0; $j < $cols; $j++) {
            $tbody .= "<td>" . $i . " " . $j . "</td>";
        }
        $tbody .= "</tr>\n";
    }
    $tfooter = "</table>";
    echo $theader . $tbody . $tfooter;
}
?>
<html>

<head>
    <title>Create Table</title>

</head>

<body>

    <center>
        <H1>TÌM HIỂU KỸ THUẬT DOM TRONG JAVASCRIPT</H1>
        <H1>(DOM: Document Object Model)</H1>
        <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="get">
            <table border=1 cellspacing=0 cellpading=0>
                <tr>
                    <td>Số dòng</td>
                    <td><input type="text" name="rows" value="<?= $rows ?>"></td>
                </tr>
                <tr>
                    <td>Số cột</td>
                    <td><input type="text" name="cols" value="<?= $cols ?>"></td>
                </tr>
                <tr>
                    <center>
                        <td></td>
                        <td colspan="2"><input type="submit" value="Hiển thị">
                            <input type="submit" value="Xóa">
                        </td>
                    </center>
                </tr>
            </table>
        </form>
        <div id="table">
            <?php
            if (isset($_GET['rows']) && isset($_GET['cols'])) {
                createTable();
            }
            ?>
        </div>

    </center>

</body>

</html>