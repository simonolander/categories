#!/bin/bash
java -classpath jooq-3.9.3.jar:jooq-meta-3.9.3.jar:jooq-codegen-3.9.3.jar:mysql-connector-java-5.1.42-bin.jar:. org.jooq.util.GenerationTool jooq-configuration.xml
