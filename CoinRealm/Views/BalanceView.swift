//
//  BalanceView.swift
//  CoinRealm
//
//  Created by J. DeWeese on 11/28/23.
//

import SwiftUI

struct BalanceView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    let amount: Float
    let curren: String
    let type: String
    let icon: String
    let iconBG: Color
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(Color(Colors.colorBlack))
                        .frame(width: 30, height: 30)
                        .background(iconBG)
                        .cornerRadius(7.5)
                    Spacer()
                    Text("\(amount.formattedWithSeparatorAndCurrency(roundingNumbers: appVM.roundingNumbers)) \(curren)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(Colors.mainText))
                }
                
                HStack {
                    Text(type)
                        .foregroundColor(.gray).textCase(.uppercase)
                        .font(.subheadline).dynamicTypeSize(.small)
                } .padding(.top, 5)
            }
            .padding(10)
            .padding(.vertical, 5)
            .background(Color(Colors.colorBalanceBG))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView(amount: 1000, curren: "$", type: "Income", icon: "plus", iconBG: .blue)
    }
}
