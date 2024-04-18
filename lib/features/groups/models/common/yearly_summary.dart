/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
class YearlySummary {
  double previousYearRemainig = 0.0;
  double expenditures = 0.0;
  double totalBankInterest = 0.0;
  double totalcredit = 0.0;

  YearlySummary(double previous, double expenditure, double bankInterest) {
    previousYearRemainig = previous;
    expenditures = expenditure;
    totalBankInterest = bankInterest;
  }
}
