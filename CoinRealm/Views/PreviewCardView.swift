//
//  PreviewCardView.swift
//  CoinRealm
//
//  Created by J. DeWeese on 11/28/23.
//

import SwiftUI

@ViewBuilder
func previewHomeTransaction() -> some View {
    VStack {
        Spacer()
        HStack(alignment: .center) {
            Spacer(minLength: 20)
            Text("Atomic")
                .foregroundStyle(.gray)
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            Image("prologo")
                .resizable()
                .frame(width: 100, height: 100)
            Text("Wallet")
                .foregroundStyle(.gray)
                .font(.system(size: 20))
                .fontWeight(.bold)
            Spacer()
        }.padding(.horizontal)
            
            Text("You have no Transactions recorded,")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            Text("press '+' and live a little.")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color(Colors.colorBalanceBG))
    }


@ViewBuilder
func previewCardTransaction() -> some View {
    VStack {
        Spacer()
        HStack(alignment: .center) {
            Spacer(minLength: 20)
            Text("Atomic")
                .foregroundStyle(.gray)
                .font(.system(size: 20))
                .fontWeight(.bold)
          
            Image("prologo")
                .resizable()
                .frame(width: 100, height: 100)
            Text("Wallet")
                .foregroundStyle(.gray)
                .font(.system(size: 20))
                .fontWeight(.bold)
            Spacer()
        }.padding(.horizontal)
           
            
            Text("The list of transactions is currently empty,")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            Text("please add transaction.")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
    }


@ViewBuilder
func previewCardCategory() -> some View {
    VStack {
        Spacer()
        HStack(alignment: .center) {
            Spacer(minLength: 20)
            Text("Atomic")
                .foregroundStyle(.gray)
                .font(.system(size: 20))
                .fontWeight(.bold)
           
            Image("prologo")
                .resizable()
                .frame(width: 100, height: 100)
            Text("Wallet")
                .foregroundStyle(.gray)
                .font(.system(size: 20))
                .fontWeight(.bold)
            Spacer()
        }.padding(.horizontal)
            
            Text("The list of categories is currently empty,")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            Text("please add category.")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
    }


func previewNoCategory() -> some View {
    VStack {
        Spacer()
        HStack(alignment: .center) {
            Spacer(minLength: 20)
            Text("Atomic")
                .foregroundStyle(.gray)
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            Image("prologo")
                .resizable()
                .frame(width: 100, height: 100)
            Text("Wallet")
                .foregroundStyle(.gray)
                .font(.system(size: 20))
                .fontWeight(.bold)
            Spacer()
        }.padding(.horizontal)
            
            Text("There are currently no transactions.")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            Text("Please add.")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color(Colors.colorBalanceBG))
    }


