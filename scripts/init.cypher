//Neo4j imports
//Account
CREATE CONSTRAINT FOR (a:Account) REQUIRE a.accountId IS UNIQUE;

Load csv with headers from 'file:///Account.csv' as row
CREATE (a:Account {accountId: toInteger(row.accountId)}) SET a.createTime = datetime(row.createTime), a.isBlocked = toBoolean(row.isBlocked), a.accountType = row.accountType, a.nickname = row.nickname, a.phonenum = toString(row.phonenum), a.email = row.email, a.freqLoginType = row.freqLoginType, a.lastLoginTime = datetime({epochmillis: toInteger(row.lastLoginTime)}), a.accountLevel = row.accountLevel;

//Medium
CREATE CONSTRAINT FOR (m:Medium) REQUIRE m.mediumId IS UNIQUE;

Load csv with headers from 'file:///Medium.CSV' as row
CREATE (m:Medium {mediumId: toInteger(row.mediumId)}) SET m.mediumType = row.mediumType, m.isBlocked = toBoolean(row.isBlocked), m.createTime = datetime(row.createTime), m.lastLoginTime = datetime({epochmillis: toInteger(row.lastLoginTime)}), m.riskLevel = row.riskLevel;

//Person
CREATE CONSTRAINT FOR (p:Person) REQUIRE p.personId IS UNIQUE;

Load csv with headers from 'file:///Person.CSV' as row
CREATE (p:Person {personId: toInteger(row.personId)}) SET p.personName = row.personName, p.isBlocked = toBoolean(row.isBlocked), p.createTime = datetime(row.createTime), p.gender = row.gender, p.birthday = date(row.birthday), p.country = row.country, p.city = row.city;

//Loan
CREATE CONSTRAINT FOR (l:Loan) REQUIRE l.loanId IS UNIQUE;

Load csv with headers from 'file:///Loan.CSV' as row
CREATE (l:Loan {loanId: toInteger(row.loanId)}) SET l.loanAmount = toFloat(row. loanAmount), l.balance = toFloat(row.balance), l.createTime = datetime(row.createTime), l.loanUsage = row.loanUsage, l.interestRate = toFloat(row.interestRate);

//Company
CREATE CONSTRAINT FOR (c:Company) REQUIRE c.companyId IS UNIQUE;

Load csv with headers from 'file:///Company.CSV' as row
CREATE (c:Company {companyId: toInteger(row.companyId)}) SET c.companyName = row. companyName, c.isBlocked = toBoolean(row.isBlocked), c.createTime = datetime(row.createTime), c.country = row.country, c.city = row.city, c.business = row.business, c.description = row.description, c.url = row.url;




//AccountRepayLoan
Load csv with headers from 'file:///AccountRepayLoan.CSV' as row 
Match (a:Account{accountId: toInteger(row.accountId)})
Match (l:Loan{loanId: toInteger(row.loanId)})
CREATE (a)-[:repay {amount: toFloat(row.amount), createTime: datetime(row.createTime)}]->(l);

//AccountTransferAccount
Load csv with headers from 'file:///AccountTransferAccount.CSV' as row
Match (a1:Account{accountId: toInteger(row.fromId)})
Match (a2:Account{accountId: toInteger(row.toId)})
CREATE (a1)-[:transfer {amount: toFloat(row.amount), createTime: datetime(row.createTime), orderNum: row.orderNum, comment: row.comment, payType: row.payType, goodsType: row.goodsType}]->(a2);

//AccountWithdrawAccount
Load csv with headers from 'file:///AccountWithdrawAccount.CSV' as row
Match (a1:Account{accountId: toInteger(row.fromId)})
Match (a2:Account{accountId: toInteger(row.toId)})
CREATE (a1)-[:withdraw {amount: toFloat(row.amount), createTime: datetime(row.createTime)}]->(a2);


//CompanyApplyLoan
Load csv with headers from 'file:///CompanyApplyLoan.CSV' as row  
Match (c:Company{companyId: toInteger(row.companyId)})
Match (l:Loan{loanId: toInteger(row.loanId)})
CREATE (c)-[:apply {createTime: datetime(row.createTime), org: row.org}]->(l); 

//CompanyGuaranteeCompany
Load csv with headers from 'file:///CompanyGuaranteeCompany.CSV' as row 
Match (c1:Company{companyId: toInteger(row.fromId)})
Match (c2:Company{ companyId: toInteger(row. toId)})
CREATE (c1)-[:guarantee {createTime: datetime(row.createTime), relation: row.relation}]->(c2);

//CompanyInvestCompany
Load csv with headers from 'file:///CompanyInvestCompany.CSV' as row
Match (c1:Company{companyId: toInteger(row.investorId)})
Match (c2:Company{ companyId: toInteger(row. companyId)})
CREATE (c1)-[:invest {ratio: toFloat(row.ratio), createTime: datetime(row.createTime)}]->(c2);

//CompanyOwnAccount
Load csv with headers from 'file:///CompanyOwnAccount.CSV' as row 
Match (c:Company{companyId: toInteger(row.companyId)})
Match (a:Account{accountId: toInteger(row.accountId)})
CREATE (c)-[:own {createTime: datetime(row.createTime)}]->(a);


//LoanDepositAccount
Load csv with headers from 'file:///LoanDepositAccount.CSV' as row 
Match (l:Loan{loanId: toInteger(row.loanId)})
Match (a:Account{accountId: toInteger(row.accountId)})
CREATE (l)-[:deposit {amount: toFloat(row.amount), createTime: datetime(row.createTime)}]->(a);


//MediumSignInAccount
Load csv with headers from 'file:///MediumSignInAccount.CSV' as row  
Match (m:Medium{mediumId: toInteger(row.mediumId)})
Match (a:Account{accountId: toInteger(row.accountId)})
CREATE (m)-[:signIn {createTime: datetime(row.createTime), location: row.location}]->(a);


//PersonApplyLoan
Load csv with headers from 'file:///PersonApplyLoan.CSV' as row 
Match (p:Person{personId: toInteger(row.personId)})
Match (l:Loan{loanId: toInteger(row.loanId)})
CREATE (p)-[:apply {createTime: datetime(row.createTime), org: row.org}]->(l);



//PersonGuaranteePerson
Load csv with headers from 'file:///PersonGuaranteePerson.CSV' as row
Match (p1:Person{personId: toInteger(row.fromId)})
Match (p2:Person{personId: toInteger(row.toId) })
CREATE (p1)-[:guarantee {createTime: datetime(row.createTime), relation: row.relation}]->(p2);

//PersonInvestCompany
Load csv with headers from 'file:///PersonInvestCompany.CSV' as row
Match (p:Person{personId: toInteger(row.investorId)})
Match (c:Company{companyId: toInteger(row.companyId)})
CREATE (p)-[:invest {ratio: toFloat(row.ratio), createTime: datetime(row.createTime)}]->(c);

//PersonOwnAccount
Load csv with headers from 'file:///PersonOwnAccount.CSV' as row 
Match (p:Person{personId: toInteger(row.personId)})
Match (a:Account{accountId: toInteger(row.accountId)})
CREATE (p)-[:own {createTime: datetime(row.createTime)}]->(a);


