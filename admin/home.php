<hr>
<div class="row">

        <div class="col-12 col-sm-4 col-md-4">
            <div class="info-box">
              <div class="info-box-content">
                <span class="info-box-text">Number of Services Avialable</span>
                <span class="info-box-number">
                  <?php 
                    $service = $conn->query("SELECT * FROM service_list where delete_flag = 0 and `status` = 1")->num_rows;
                    echo format_num($service);
                  ?>
                  <?php ?>
                </span>
              </div>
              <!-- /.info-box-content -->
            </div>
            <!-- /.info-box -->
          </div>
          <!-- /.col -->

          <div class="col-12 col-sm-4 col-md-4">
            <div class="info-box">
              <div class="info-box-content">
                <span class="info-box-text">Number of Products in-stock</span>
                <span class="info-box-number">
                  <?php 
                    $product = $conn->query("SELECT * FROM product_list where delete_flag = 0 and `status` = 1")->num_rows;
                    echo format_num($product);
                  ?>
                  <?php ?>
                </span>
              </div>
              <!-- /.info-box-content -->
            </div>
            <!-- /.info-box -->
          </div>
          <!-- /.col -->

          <div class="col-12 col-sm-4 col-md-4">
            <div class="info-box">
              <div class="info-box-content">
                <span class="info-box-text">Peding Transactions</span>
                <span class="info-box-number">
                  <?php 						
                    if($_settings->userdata('type') == 2):
                      $total = $conn->query("SELECT * FROM transaction_list where `status` = 0 and tech_id = '{$_settings->userdata('id')}' ")->num_rows;
                    else:
                      $total = $conn->query("SELECT * FROM transaction_list where `status` = 0 ")->num_rows;
                    endif;
                    echo format_num($total);
                  ?>
                  <?php ?>
                </span>
              </div>
              <!-- /.info-box-content -->
            </div>
            <!-- /.info-box -->
          </div>
          <!-- /.col -->

          <div class="col-12 col-sm-4 col-md-4">
            <div class="info-box">
              <div class="info-box-content">
                <span class="info-box-text">On-Progress Transactions</span>
                <span class="info-box-number">
                  <?php 
                    if($_settings->userdata('type') == 2):
                      $total = $conn->query("SELECT * FROM transaction_list where `status` = 1 and tech_id = '{$_settings->userdata('id')}' ")->num_rows;
                    else:
                      $total = $conn->query("SELECT * FROM transaction_list where `status` = 1 ")->num_rows;
                    endif;
                    echo format_num($total);
                  ?>
                  <?php ?>
                </span>
              </div>
              <!-- /.info-box-content -->
            </div>
            <!-- /.info-box -->
          </div>
          <!-- /.col -->

        <div class="col-12 col-sm-4 col-md-4">
          <div class="info-box">
              <div class="info-box-content">
                <form method="GET" action="">
                  <div class="input-group">
                    <input type="text" name="transaction_id" class="form-control" placeholder="Enter Invoice Number" required>
                      <div class="input-group-append">
                        <button type="submit" class="btn btn-primary">Search</button>
                      </div>
                  </div>
                </form>
                <span class="info-box-number">
                <?php
                if (isset($_GET['transaction_id']) && !empty($_GET['transaction_id'])) {
                    // Sanitize the input to prevent SQL injection
                    $search_transaction_id = intval($_GET['transaction_id']);

                    // Call the stored procedure to get transaction details
                    $stmt = $conn->prepare("CALL GetTransactionInfo(?)");
                    $stmt->bind_param("i", $search_transaction_id);
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $stmt->close();

                    // Display the details of the found transaction
                    if ($result->num_rows > 0) {
                        $transaction = $result->fetch_assoc();
                        echo "Invoice Number : " . $transaction['code'] . "<br>";
                        echo "Customer Name : " . $transaction['client_name'] . "<br>";
                        echo "Amount : " . $transaction['amount'] . "<br>";
                        
                        // Display human-readable status
                        $statusMapping = [
                            0 => 'Pending',
                            1 => 'On-Progress',
                            2 => 'Done',
                            // Add more mappings as needed
                        ];
                        echo "Status : " . $statusMapping[$transaction['status']] . "<br>";
                        echo "Assigned Technician ID : " . $transaction['tech_id'] . "<br>";
                        
                    } else {
                        echo "Transaction not found.";
                    }
                }
                ?>
                </span>
              </div>
              <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </div>
        <!-- /.col -->


<?php
if ($_settings->userdata('type') == 1):
?>
        <div class="col-12 col-sm-4 col-md-4">
          <div class="info-box">
            <div class="info-box-content">
              <form method="GET" action="">
                <div class="input-group">
                  <input type="text" name="tech_id" class="form-control" placeholder="Enter Technician ID" required>
                  <div class="input-group-append">
                    <button type="submit" class="btn btn-primary">Search</button>
                  </div>
                </div>
              </form>
              <span class="info-box-number">
                <?php
                if (isset($_GET['tech_id']) && !empty($_GET['tech_id'])) {
                    // Sanitize the input to prevent SQL injection
                    $search_tech_id = intval($_GET['tech_id']);

                    // Call the stored procedure to get the number of transactions for the technician
                    $stmt = $conn->prepare("CALL GetTransactionCountPerTechnician(?)");
                    $stmt->bind_param("i", $search_tech_id);
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $stmt->close();

                    // Display the result
                    if ($result->num_rows > 0) {
                        $row = $result->fetch_assoc();
                        echo "Technician ID: " . htmlspecialchars($row['tech_id']) . "<br>";
                        echo "Technician Name: " . htmlspecialchars($row['tech_fname']);
                        echo ' ';
                        echo htmlspecialchars($row['tech_lname']) . "<br>";
                        echo "Total Transactions: " . $row['transaction_count'] . "<br>";
                    } else {
                        echo "Technician not found.";
                    }
                }
                ?>
              </span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </div>
        <!-- /.col -->


        <div class="col-12 col-sm-4 col-md-4">
          <div class="info-box">
            <div class="info-box-content">
              <span class="info-box-text">Technician with the highest number of transactions</span>
                <span class="info-box-number">
                  <?php 
                    $result = $conn->query("SELECT u.id AS tech_id, u.firstname AS tech_fname, u.lastname AS tech_lname, counts.transaction_count AS max_transaction_count
                                            FROM users u
                                            LEFT JOIN (
                                                SELECT tech_id, COUNT(id) AS transaction_count
                                                FROM transaction_list
                                                GROUP BY tech_id
                                            ) counts ON u.id = counts.tech_id
                                            WHERE counts.transaction_count = (SELECT MAX(transaction_count) 
                                                                              FROM (SELECT COUNT(id) AS transaction_count FROM transaction_list GROUP BY tech_id) max_counts)");

                    if ($result->num_rows > 0) {
                        while ($row = $result->fetch_assoc()) {
                          echo "Technician ID : " . htmlspecialchars($row['tech_id']) . "<br>";
                          echo "Technician Name : " . htmlspecialchars($row['tech_fname']);
                          echo ' ';
                          echo htmlspecialchars($row['tech_lname']) . "<br>";
                          echo "Total Transactions : " . $row['max_transaction_count'] . "<br>";
                          echo "\n". "<br>";
                        }
                    } 
                    else {
                        echo "No data available.";
                    }
                  ?>
                </span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </div>
        <!-- /.col -->
<?php
// End of code for administrators
endif;
?>
        
</div>