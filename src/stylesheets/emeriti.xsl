<?xml version="1.0"?>
<!--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:pom="http://maven.apache.org/POM/4.0.0"
    version="1.0">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:template match="//pom:developers">
    <h2><xsl:text>Velocity Emeriti</xsl:text></h2>
    <table class="standard">
      <thead>
        <tr>
          <th>Name</th>
          <th>Id</th>
          <th>Email</th>
          <th>Organization</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="pom:developer[count(pom:roles/pom:role[contains(text(),'Emeritus')])=1]"/>
      </tbody>
    </table>
  </xsl:template>
  <xsl:template match="//pom:developer">
    <tr>
      <td><xsl:value-of select="pom:name/text()"/></td>
      <td><xsl:value-of select="pom:id/text()"/></td>
      <td><xsl:value-of select="pom:email/text()"/></td>
      <td><xsl:value-of select="pom:organization/text()"/></td>
    </tr>
  </xsl:template>
  <xsl:template match="text()"/>
</xsl:stylesheet>
