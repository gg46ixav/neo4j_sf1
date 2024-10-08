//Neo4j imports
//Account
CREATE CONSTRAINT FOR (a:Account) REQUIRE a.accountId IS UNIQUE;
Load csv with headers from 'file:///Account.csv' as row
FIELDTERMINATOR '|' CREATE (a:Account {accountId: toInteger(row.accountId)}) SET a.createTime = datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), a.isBlocked = toBoolean(row.isBlocked), a.accountType = row.accountType, a.nickname = row.nickname, a.phonenum = toString(row.phonenum), a.email = row.email, a.freqLoginType = row.freqLoginType, a.lastLoginTime = datetime({epochmillis: toInteger(row.lastLoginTime)}), a.accountLevel = row.accountLevel;

//Medium
CREATE CONSTRAINT FOR (m:Medium) REQUIRE m.mediumId IS UNIQUE;

Load csv with headers from 'file:///Medium.csv' as row
FIELDTERMINATOR '|' CREATE (m:Medium {mediumId: toInteger(row.mediumId)}) SET m.mediumType = row.mediumType, m.isBlocked = toBoolean(row.isBlocked), m.createTime = datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), m.lastLoginTime = datetime({epochmillis: toInteger(row.lastLoginTime)}), m.riskLevel = row.riskLevel;

//Person
CREATE CONSTRAINT FOR (p:Person) REQUIRE p.personId IS UNIQUE;

Load csv with headers from 'file:///Person.csv' as row
FIELDTERMINATOR '|' CREATE (p:Person {personId: toInteger(row.personId)}) SET p.personName = row.personName, p.isBlocked = toBoolean(row.isBlocked), p.createTime = datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), p.gender = row.gender, p.birthday = date(row.birthday), p.country = row.country, p.city = row.city;

//Loan
CREATE CONSTRAINT FOR (l:Loan) REQUIRE l.loanId IS UNIQUE;

Load csv with headers from 'file:///Loan.csv' as row
FIELDTERMINATOR '|' CREATE (l:Loan {loanId: toInteger(row.loanId)}) SET l.loanAmount = toFloat(row. loanAmount), l.balance = toFloat(row.balance), l.createTime = datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), l.loanUsage = row.loanUsage, l.interestRate = toFloat(row.interestRate);

//Company
CREATE CONSTRAINT FOR (c:Company) REQUIRE c.companyId IS UNIQUE;

Load csv with headers from 'file:///Company.csv' as row
FIELDTERMINATOR '|' CREATE (c:Company {companyId: toInteger(row.companyId)}) SET c.companyName = row. companyName, c.isBlocked = toBoolean(row.isBlocked), c.createTime = datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), c.country = row.country, c.city = row.city, c.business = row.business, c.description = row.description, c.url = row.url;




//AccountRepayLoan
Load csv with headers from 'file:///AccountRepayLoan.csv' as row 
Match (a:Account{accountId: toInteger(row.accountId)})
Match (l:Loan{loanId: toInteger(row.loanId)})
FIELDTERMINATOR '|' CREATE (a)-[:repay {amount: toFloat(row.amount), createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss")))}]->(l);

//AccountTransferAccount
Load csv with headers from 'file:///AccountTransferAccount.csv' as row
Match (a1:Account{accountId: toInteger(row.fromId)})
Match (a2:Account{accountId: toInteger(row.toId)})
FIELDTERMINATOR '|' CREATE (a1)-[:transfer {amount: toFloat(row.amount), createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), orderNum: row.orderNum, comment: row.comment, payType: row.payType, goodsType: row.goodsType}]->(a2);

//AccountWithdrawAccount
Load csv with headers from 'file:///AccountWithdrawAccount.csv' as row
Match (a1:Account{accountId: toInteger(row.fromId)})
Match (a2:Account{accountId: toInteger(row.toId)})
FIELDTERMINATOR '|' CREATE (a1)-[:withdraw {amount: toFloat(row.amount), createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss")))}]->(a2);


//CompanyApplyLoan
Load csv with headers from 'file:///CompanyApplyLoan.csv' as row  
Match (c:Company{companyId: toInteger(row.companyId)})
Match (l:Loan{loanId: toInteger(row.loanId)})
FIELDTERMINATOR '|' CREATE (c)-[:apply {createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), org: row.org}]->(l); 

//CompanyGuaranteeCompany
Load csv with headers from 'file:///CompanyGuaranteeCompany.csv' as row 
Match (c1:Company{companyId: toInteger(row.fromId)})
Match (c2:Company{ companyId: toInteger(row. toId)})
FIELDTERMINATOR '|' CREATE (c1)-[:guarantee {createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), relation: row.relation}]->(c2);

//CompanyInvestCompany
Load csv with headers from 'file:///CompanyInvestCompany.csv' as row
Match (c1:Company{companyId: toInteger(row.investorId)})
Match (c2:Company{ companyId: toInteger(row. companyId)})
FIELDTERMINATOR '|' CREATE (c1)-[:invest {ratio: toFloat(row.ratio), createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss")))}]->(c2);

//CompanyOwnAccount
Load csv with headers from 'file:///CompanyOwnAccount.csv' as row 
Match (c:Company{companyId: toInteger(row.companyId)})
Match (a:Account{accountId: toInteger(row.accountId)})
FIELDTERMINATOR '|' CREATE (c)-[:own {createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss")))}]->(a);


//LoanDepositAccount
Load csv with headers from 'file:///LoanDepositAccount.csv' as row 
Match (l:Loan{loanId: toInteger(row.loanId)})
Match (a:Account{accountId: toInteger(row.accountId)})
FIELDTERMINATOR '|' CREATE (l)-[:deposit {amount: toFloat(row.amount), createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss")))}]->(a);


//MediumSignInAccount
Load csv with headers from 'file:///MediumSignInAccount.csv' as row  
Match (m:Medium{mediumId: toInteger(row.mediumId)})
Match (a:Account{accountId: toInteger(row.accountId)})
FIELDTERMINATOR '|' CREATE (m)-[:signIn {createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), location: row.location}]->(a);


//PersonApplyLoan
Load csv with headers from 'file:///PersonApplyLoan.csv' as row 
Match (p:Person{personId: toInteger(row.personId)})
Match (l:Loan{loanId: toInteger(row.loanId)})
FIELDTERMINATOR '|' CREATE (p)-[:apply {createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), org: row.org}]->(l);



//PersonGuaranteePerson
Load csv with headers from 'file:///PersonGuaranteePerson.csv' as row
Match (p1:Person{personId: toInteger(row.fromId)})
Match (p2:Person{personId: toInteger(row.toId) })
FIELDTERMINATOR '|' CREATE (p1)-[:guarantee {createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss"))), relation: row.relation}]->(p2);

//PersonInvestCompany
Load csv with headers from 'file:///PersonInvestCompany.csv' as row
Match (p:Person{personId: toInteger(row.investorId)})
Match (c:Company{companyId: toInteger(row.companyId)})
FIELDTERMINATOR '|' CREATE (p)-[:invest {ratio: toFloat(row.ratio), createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss")))}]->(c);

//PersonOwnAccount
Load csv with headers from 'file:///PersonOwnAccount.csv' as row 
Match (p:Person{personId: toInteger(row.personId)})
Match (a:Account{accountId: toInteger(row.accountId)})
FIELDTERMINATOR '|' CREATE (p)-[:own {createTime: datetime(apoc.date.format(toInteger(row.createTime),('ms'),("yyyy-MM-dd'T'HH:mm:ss")))}]->(a);


