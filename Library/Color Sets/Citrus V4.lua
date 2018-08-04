function citrusColor(name,main,inverse,...)
	local alias = {...}
	for i,v in pairs(main)do
		main[i] = Spice.Color.fromHex(v)
	end
	local inv = {}
	for i,v in pairs(inverse)do
		inverse[i] = Spice.Color.fromHex(v)
		inv[#inverse-i+1] = inverse[i]
	end
	local new = main
	main.Inverse = inv
	Spice.Color.Colors.new(name,new,'CitrusV4')
end

citrusColor('Ruby',{'EA8A97';
				'E06071';
				'CF3F4E';
				'C43140';
				'9E1F2C';
				'891A27';
				'77111F';}, 
				{'EE8896';
						'E57683';
						'E0616E';
						'CE3B4A';
						'C0303F';
						'9F1F30';
'751522';})

citrusColor('Red',{'EA8B8A','E06260','CF463F','C43831','9E251F','891E1A','771211'},
	{'EE8988','E57A76','E06761','CE423B','C03730','9F211F','751615'},'Mahogany'
)
citrusColor('Deep orange',{'EA958A','E06F60','CF543F','C44731','9E321F','89291A','771D11'},
	{'EE9488','E58576','E07461','CE513B','C04530','9F2E1F','752015'},'Peach','Mojo'
)
citrusColor('Orange',{'EAA58A','E08460','CF6C3F','C45F31','9E471F','893B1A','772E11'},
	{'EEA588','E59776','E08961','CE693B','C05D30','9F431F','753015'},'Raw sienna','Tuscany'
)
citrusColor('Yellow',{'EAC58A','E0AF60','CF9C3F','C49031','9E711F','89601A','775011'},
	{'EEC788','E5BC76','E0B361','CE9A3B','C08D30','9F6E1F','755015'},'Gold'
)
citrusColor('Lime',{'C7EA8A','B1E060','96CF3F','8AC431','6C9E1F','5F891A','527711'},
	{'C9EE88','BBE576','AEE061','94CE3B','87C030','709F1F','527515'}, 'Pear','Atlantis'
)
citrusColor('Mint',{'8AEABD','60E0A4','3FCF90','31C484','1F9E67','1A8957','117747'},
	{'88EEBE','76E5B3','61E0A9','3BCE8E','30C081','1F9F63','157548'},'Jade','Shamrock','Jewel'
)
citrusColor('Green',{'8AEA95','60E06F','3FCF54','31C447','1F9E32','1A8929','11771D'},
	{'88EE94','76E585','61E074','3BCE51','30C045','1F9F2E','157520'},'Apple','Emerald'
)
citrusColor("Teal",{'8AEADD','60E0CF','3FCFC0','31C4B5','1F9E91','1A897C','117769'},
	{'88EEE0','76E5D8','61E0D3','3BCEBF','30C0B1','1F9F8E','157568'},'Aquamarine'
)
citrusColor("Cyan",{'8ADFEA','60D1E0','3FBACF','31AEC4','1F8B9E','1A7A89','116C77'},
	{'88E3EE','76D6E5','61CDE0','3BB8CE','30ABC0','1F909F','156A75'}
)
citrusColor("Light blue",{'8ACFEA','60BCE0','3FA2CF','3196C4','1F769E','1A6889','115B77'},
	{'88D2EE','76C4E5','61B8E0','3BA0CE','3093C0','1F7B9F','155A75'},'Cornflower','Blumine'
)
citrusColor('Blue',{'8AAFEA','6091E0','3F72CF','3165C4','1F4C9E','1A4389','113877'},
	{'88AFEE','769FE5','618EE0','3B6FCE','3063C0','1F509F','153A75'},'Indigo','Cerulean blue'
)
citrusColor('Purple',{'AD8AEA','8F60E0','783FCF','6C31C4','521F9E','441A89','361177'},
	{'AD88EE','A076E5','9461E0','763BCE','6930C0','4E1F9F','381575'}
)
citrusColor('Pink',{'EA8ADF','E060D1','CF3FBA','C431AE','9E1F8B','891A7A','77116B'},
	{'EE88E2','E576D6','E061CD','CE3BB8','C030AB','9F1F90','75156A'},'Violet','Orchid'
)
citrusColor('Hot pink',{'EA8AB7','E0609C','CF3F7E','C43171','9E1F56','891A4C','771141'},
	{'EE88B8','E576A8','E06198','CE3B7B','C0306F','9F1F5B','751542'},'Rose'
)
