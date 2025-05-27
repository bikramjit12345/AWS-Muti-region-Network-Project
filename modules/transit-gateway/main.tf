# Create the TGW

resource "aws_ec2_transit_gateway" "tgw" {
  description                    = "Transit Gatway"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "${var.name}-tgw"
  }
}

# Attach vpc

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc_att" {

  subnet_ids         = var.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.vpc_id
}


# Create Route table in default table 
resource "aws_ec2_transit_gateway_route" "tgw_route" {

  destination_cidr_block         = var.destination_vpc
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
  transit_gateway_attachment_id  = var.peering_attachment_id


  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_att]

}

